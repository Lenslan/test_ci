import shutil
import time
from datetime import datetime
import sys
import os
import re
import textwrap
import hashlib



class Bits:
    def __init__(self, width, value=None):
        self.width = width
        self.value = value
        if isinstance(value, int):
            self.value = value
            self.width_check()
        elif isinstance(value, str):
            self.value = int(value)
            self.width_check()

    def __str__(self):
        if isinstance(self.value, int):
            if self.value < 0:
                return bin(self.value & ((1<<self.width)-1))[2:]
            else:
                return bin(self.value)[2:].rjust(self.width, '0')
        elif isinstance(self.value, list):
            return "".join(self.value)

    def __bool__(self):
        return self.value != 0

    def __lt__(self, other):
        return self.value < other

    def __le__(self, other):
        return self.value <= other

    def __gt__(self, other):
        return self.value > other

    def __eq__(self, other):
        return self.value == other

    def __xor__(self, other):
        return self.__bool__() ^ other

    def get_width(self):
        if isinstance(self.value, list):
            return len(self.value)
        return self.value.bit_length()

    def width_check(self):
        if self.width < self.get_width():
            raise OverflowError("width check error")

    def set_value(self, value):
        if isinstance(value, int):
            self.value = value
        elif isinstance(value, str):
            self.value = int(value, 10)
        elif isinstance(value, list):
            self.value = value
        self.width_check()

def cap_overflow(func):
    def wrapper(self, *args, **kwargs):
        try:
            func(self, *args, **kwargs)
        except OverflowError as e:
            raise OverflowError(f"[ERROR] width check overflow at line {self.lineNumber}")
    return wrapper

class ErrorMsg:
    err_list = []

    @classmethod
    def add_error(cls, msg):
        cls.err_list.append(msg)

    @classmethod
    def has_error(cls):
        return len(cls.err_list) > 0

class StateBase:
    def __init__(self, s, n):
        self.infoString = s
        self.lineNumber = n

    def __str__(self):
        pass

    def parse_string(self):
        pass

    def re_parse_number(self, s):
        ret = self.infoString.split(s)
        res = re.search(r'= *(\d+)', ret[1])
        if not res:
            raise ValueError(f"[ERROR] re match Error for {s} at line {self.lineNumber}")
        return res.group(1)

class StateInfo(StateBase):
    def __init__(self, s, n):
        super().__init__(s, n)
        self.nb_trans = Bits(3)
        self.cmdEn = Bits(1)
        self.cmdExtEn = Bits(1)
        self.timeOutEn = Bits(1)
        self.sleepEn = Bits(1)
        self.timeOutValue = Bits(11)
        self.dspEn = Bits(15)
        self.parse_string()

    def __str__(self):
        return f"{self.nb_trans}{self.cmdEn}{self.timeOutEn}{self.sleepEn}{self.timeOutValue}{self.dspEn}"

    @cap_overflow
    def parse_string(self):
        self.nb_trans.set_value(self.re_parse_number("nb_trans"))
        self.cmdEn.set_value(self.re_parse_number("cmdEn"))
        self.cmdExtEn.set_value(self.re_parse_number("cmdExtEn"))
        self.timeOutEn.set_value(self.re_parse_number("timeOutEn"))
        self.sleepEn.set_value(self.re_parse_number("sleepEn"))
        self.timeOutValue.set_value(self.re_parse_number("timeOutVal"))

        ret = self.infoString.split("dspEn")
        res = re.search(r'= *\[([ \d]+)]', ret[1])
        if not res:
            raise ValueError(f"[ERROR] re match Error for dspEn at line {self.lineNumber}")
        self.dspEn.set_value(res.group(1).strip().split())


class StateCmd(StateBase):
    def __init__(self, s, n):
        super().__init__(s, n)
        self.cmd = Bits(8)
        self.param2 = Bits(8)
        self.param1 = Bits(8)
        self.param0 = Bits(8)
        self.parse_string()

    def __str__(self):
        return f"{self.cmd}{self.param2}{self.param1}{self.param0}"

    @cap_overflow
    def parse_string(self):
        self.cmd.set_value(self.re_parse_number("cmd"))

        ret = self.infoString.split("param")
        res = re.search(r'= *\[([- \d,]+)]', ret[1])
        if not res:
            raise ValueError(f"[ERROR] re match Error for param at line {self.lineNumber}")
        res = re.split("[ ,]", res.group(1).strip())
        self.param2.set_value(res[0])
        self.param1.set_value(res[1])
        self.param0.set_value(res[2])


class StateTransition(StateBase):
    def __init__(self, s, n):
        super().__init__(s, n)
        self.cond1 = Bits(7)
        self.cond2 = Bits(6)
        self.cond3 = Bits(6)
        self.pathComb = Bits(1)
        self.combOrAnd = Bits(3)
        self.tmp_targetAddr = ""
        self.targetAddr = Bits(9)
        self.parse_string()

    def __str__(self):
        return f"{self.cond1}{self.cond2}{self.cond3}{self.pathComb}{self.combOrAnd}{self.targetAddr}"

    def __bool__(self):
        return self.have_timeout

    def status_map(self, s):
        StatusMapDist = {
            "false" : 0,
            "true" : 1,
            "timeOut" : 2,
            "satCount0" : 3,
            "satCount1" : 4,
            "satCount2" : 5,
            "satCount3" : 6,
            "satCount4" : 7,
            "genCount0" : 8,
            "genCount1" : 9,
            "genCount2" : 10,
            "adcPowdBmRad" : 11,
            "channelBW80" : 12,
            "noRFGainUpt" : 13,
            "rfGainCp2Max" : 14,
            "rfGainCp2Min" : 15,
            "rfGainCp2Min4Sat" : 16,
            "demodRun" : 17,
            "cmdCtrlFlag" : 18,
            "extTrigger" : 19,
            "sat" : 20,
            "crossUp" : 21,
            "crossDn" : 22,
            "rampUp" : 23,
            "rampDn" : 24,
            "adcPowDis" : 25,
            "stablePow" : 26,
            "ofdmCC" : 27,
            "ofdmAC" : 28,
            "dsssCC" : 29,
            "dsssAC" : 30,
            "foundSFD" : 31,
            "noGainUpt" : 32,
            "channelBW20" : 33,
            "channelBW40" : 34,
            "validLSIG" : 35,
            "validHTSIG" : 36,
            "rxEnd4Timing" : 37,
            "rxHETBEn" : 38,
            "ofdmOnly" : 39,
            "rifsDet" : 40,
            "inbdPowSup" : 41,
            "inbdPowInf" : 42,
            "adcPowSup" : 43,
            "adcPowInf" : 44,
            "adcPowdBmSup" : 45,
            "adcPowdBmInf" : 46,
            "idPow" : 47,
            "htstfStEst" : 48,
            "htstfGainUpdt" : 49,
            "fomHigh" : 50,
            "fomMed" : 51,
            "fomSing" : 52,
            "freqHigh" : 53,
            "freqLow" : 54,
            "freqSing" : 55,
            "freqDC" : 56,
            "lengthHigh" : 57,
            "lengthLow" : 58,
            "meas1Done" : 59,
            "meas2Done" : 60,
            "meas3Done" : 61,
            "radarDet" : 62,
            "dsssContDet" : 63,
            "OFDMPackDet" : 64,
            "LNASatDet" : 65,
            "OFDMPacVerify" : 66,
            "LTFSYNC" : 67,
            "RxTdmaEn" : 68
        }
        v = StatusMapDist.get(s)
        if v is None:
            raise ValueError(f"[ERROR] status map error for {s} in line {self.lineNumber}")
        return v

    @cap_overflow
    def parse_string(self):
        res = re.findall(r'= *\'(\w+)\'', self.infoString)
        if len(res) != 4:
            raise ValueError(f"[ERROR] re match Error for transition at line {self.lineNumber}")
        self.cond1.set_value(self.status_map(res[0]))
        self.cond2.set_value(self.status_map(res[1]))
        self.cond3.set_value(self.status_map(res[2]))
        self.tmp_targetAddr = res[3]

        self.pathComb.set_value(self.re_parse_number("pathComb"))
        self.combOrAnd.set_value(self.re_parse_number("opComb"))

    @cap_overflow
    def target_addr_remap(self, map_dist):
        res = map_dist.get(self.tmp_targetAddr)
        if res is None:
            # raise ValueError(f"[ERROR] no target addr {self.tmp_targetAddr} at line {self.lineNumber}")
            ErrorMsg.add_error(f"[ERROR] no target addr {self.tmp_targetAddr} at line {self.lineNumber}")
            return
        self.targetAddr.set_value(res)

    @property
    def have_timeout(self):
        timeout = self.status_map("timeOut")
        if self.cond1 == timeout:
            return True
        if self.cond2 == timeout:
            return True
        if self.cond3 == timeout:
            return True
        return False



class StateInst(StateBase):
    def __init__(self, s, n, n2):
        super().__init__(s, n)
        self.memAddr = n2
        self.info = None
        self.cmd = None
        self.Trans = []
        self.name = ""
        self.PreState = []
        self.PostState = []
        self.RootState = ""
        self.parse_string()

    def __str__(self):
        s = str(self.info)
        if self.cmd:
            s += str(self.cmd)
        for t in self.Trans:
            s += str(t)
        return s

    def __len__(self):
        if not self.cmd:
            n = 1
        else:
            n = 2
        return n+len(self.Trans)

    def parse_string(self):
        ret = re.search(r'\'(\w*)\'', self.infoString)
        if not ret:
            raise ValueError(f"[ERROR] re match error at line {self.lineNumber}")
        self.name = ret.group(1)

    def set_info(self, s, n):
        self.info = StateInfo(s, n)

    def set_cmd(self, s, n):
        self.cmd = StateCmd(s, n)

    def set_trans(self, s, n):
        self.Trans.append(StateTransition(s, n))

    def set_cmd_or_trans(self, s, n):
        if self.info.cmdEn:
            self.set_cmd(s, n)
        else:
            self.set_trans(s, n)

    def check(self):
        self.check_nb_trans()
        self.check_timeout_en()
        self.check_cmd_en()

    def check_nb_trans(self):
        if self.info.nb_trans != len(self.Trans):
            # raise ValueError(f"[ERROR] unmatch of number_transition in state {self.name} at line {self.info.lineNumber}")
            ErrorMsg.add_error(f"[ERROR] unmatch of number_transition in state {self.name} at line {self.info.lineNumber}")

    def check_cmd_en(self):
        if self.info.cmdEn ^ (self.cmd is not None):
            # raise ValueError(f"[ERROR] cmdEn error in state {self.name} at line {self.info.lineNumber}")
            ErrorMsg.add_error(f"[ERROR] cmdEn error in state {self.name} at line {self.info.lineNumber}")

    def check_timeout_en(self):
        if self.info.timeOutEn and self.info.timeOutValue <= 0:
            # raise ValueError(f"[ERROR] timeout value must more than zero at line {self.info.lineNumber}")
            ErrorMsg.add_error(f"[ERROR] timeout value must more than zero at line {self.info.lineNumber}")
        if self.info.timeOutEn ^ any(self.Trans):
            # raise ValueError(f"[ERROR] usage of timeout status error at line {self.lineNumber}")
            ErrorMsg.add_error(f"[ERROR] usage of timeout status error at line {self.lineNumber}")



class StateFactory:
    def __init__(self, ram_max, target_dir):
        self.StateList = []
        self.StateMap = {}
        self.lineNumber = 0
        self.ramSizeNumber = 0
        self.state_string = None
        self.ramMax = ram_max
        self.targetDir = target_dir

    def __str__(self):
        res = self.get_state_string
        sig = self.gen_signature
        res += sig
        return res

    @property
    def get_state_string(self):
        if self.state_string:
            return self.state_string
        res = ""
        for s in self.StateList:
            res += str(s)
        res += '0' * 32 * (self.ramMax - self.ramSizeNumber - 1)
        self.state_string = res
        return res

    def mem_size_check(self):
        if self.ramSizeNumber > self.ramMax - 1:
            raise OverflowError(f"[ERROR] agc ram overflow, the usage of ram is {self.ramSizeNumber}")


    def new_state(self, s):
        ret = StateInst(s, self.lineNumber, self.ramSizeNumber)
        self.StateList.append(ret)
        self.StateMap[ret.name] = self.ramSizeNumber


    def target_addr_translate(self):
        for state in self.StateList:
            for t in state.Trans:
                t.target_addr_remap(self.StateMap)

    def check_all(self):
        self.mem_size_check()
        for s in self.StateList:
            s.check()
        if ErrorMsg.has_error():
            raise ValueError("\n\n".join(ErrorMsg.err_list))

    def parse_line(self, s):
        self.lineNumber += 1
        if s.startswith("case"):
            self.new_state(s)
        elif s.startswith("nb_trans"):
            self.StateList[-1].set_info(s, self.lineNumber)
            self.ramSizeNumber += 1
        elif s.startswith("cmd"):
            self.StateList[-1].set_cmd(s, self.lineNumber)
            self.ramSizeNumber += 1
        elif s.startswith("op{"):
            self.StateList[-1].set_trans(s, self.lineNumber)
            self.ramSizeNumber += 1


    def traverse_all(self, gen):
        gen.pre_gen()
        for s in self.StateList:
            gen.gen(s)
        gen.post_gen()

    @property
    def state_number(self):
        return len(self.StateList)

    @property
    def addr_ram_max(self):
        return hex(self.ramSizeNumber)

    def parse_file(self, f):
        with open(f, "r", encoding='utf-8') as fp:
            for line in fp:
                self.parse_line(line.strip())

    @property
    def gen_signature(self):
        res = self.get_state_string
        res = textwrap.wrap(res, 32)
        sig = [int(i) for i in "0"*31+"1"]
        for tmp in res:
            value = [int(i, 2) for i in tmp]
            sig_tmp = [i ^ j for i, j in zip(sig[1:32], value[0:31])]
            sig_tmp.append(value[31] ^ (sig[0] ^ sig[4] ^ sig[5] ^ sig[31])) # TODO
            sig = sig_tmp
        return "".join([str(i) for i in sig])

    def gen_agc_32_txt(self):
        s = textwrap.wrap(self.__str__(), 32)
        with open(os.path.join(self.targetDir, "agc32.txt"), 'w') as f:
            f.write("\n".join(s))
            f.write("\n")

    def gen_agc_32_hex_txt(self):
        s = textwrap.wrap(self.__str__(), 32)
        s = map(lambda x: hex(int(x, 2))[2:].rjust(8, "0"), s)
        with open(os.path.join(self.targetDir, "agc.32_hex"), 'w') as f:
            f.write("\n".join(s))
            f.write("\n")

    def gen_agc_hex_txt(self):
        s = textwrap.wrap(self.__str__(), 64)
        s = map(lambda x: x[8:16]+x[0:8],
            map(lambda x: hex(int(x, 2))[2:].rjust(16, "0"), s))
        with open(os.path.join(self.targetDir, "agc.hex"), "w") as f:
            f.write("\n".join(s))
            f.write("\n")

    def gen_agc_byte_hex(self):
        s = textwrap.wrap(self.__str__(), 32)
        s = map(lambda x: hex(int(x, 2))[2:].rjust(8, "0"), s)
        s = [f"{x[6:8]}\n{x[4:6]}\n{x[2:4]}\n{x[0:2]}" for x in s]
        with open(os.path.join(self.targetDir, "agc.byte_hex"), "w") as f:
            f.write("\n".join(s))
            f.write("\n")

    def gen_agc_txt(self):
        s = textwrap.wrap(self.__str__(), 64)
        s = [x[32:64]+x[0:32] for x in s]
        with open(os.path.join(self.targetDir, "agc.txt"), "w") as f:
            f.write("\n".join(s))
            f.write("\n")


    def gen_agc_bin(self):
        s = textwrap.wrap(self.__str__(), 32)
        with open(os.path.join(self.targetDir, "agcram.bin"), 'wb') as f:
            for data in s:
                v = int(data, 2).to_bytes(4, "little")
                f.write(v)

    def gen_md5_txt(self):
        s = textwrap.wrap(self.__str__(), 32)
        data = b''.join([int(v, 2).to_bytes(4, "little") for v in s])
        md5 = hashlib.md5(data).hexdigest()
        with open(os.path.join(self.targetDir, f"{md5}.txt"), 'w') as f:
            pass


    def base_doc_generate(self):
        if not os.path.exists(self.targetDir):
            os.mkdir(self.targetDir)
        self.gen_agc_32_txt()
        self.gen_agc_32_hex_txt()
        self.gen_agc_hex_txt()
        self.gen_agc_byte_hex()
        self.gen_agc_txt()
        self.gen_agc_bin()
        self.gen_md5_txt()

    def run(self, p):
        self.parse_file(p)
        self.target_addr_translate()
        self.check_all()
        self.base_doc_generate()
        shutil.copy(p, self.targetDir)


#####################################################################################


class AgcFilePrinter:
    def __init__(self, target_dir):
        self.targetDir = target_dir
        if not os.path.exists(self.targetDir):
            os.mkdir(self.targetDir)
        self.agc_la_fp = None
        self.agc_alise_fp = None

    def pre_gen(self):
        self.agc_la_fp = open(os.path.join(self.targetDir, "agc.la"), 'w')
        self.agc_alise_fp = open(os.path.join(self.targetDir, "agc.alias"), "w")
        self.agc_alise_fp.write("alias    alias_table_agc_state\n")

    def gen(self, s):
        for i in range(s.memAddr, s.memAddr+len(s)):
            self.agc_la_fp.write("{:>8d} {:>32s}\n".format(i, s.name))
            self.agc_alise_fp.write("{:>32s} {:>8d}\n".format(s.name, i))


    def post_gen(self):
        self.agc_la_fp.close()
        self.agc_alise_fp.write("endalias\n")
        self.agc_alise_fp.close()

def get_date():
    return datetime.now().strftime('%Y_%m_%d_%H_%M_%S')

def get_band(f):
    band = '_'
    bw = ''
    if 'hb' in f:
        band = band + 'hb'
    elif 'lb' in f:
        band = band + 'lb'
    
    if 'CBW20' in f:
        bw = '20'
    elif 'CBW40' in f:
        bw = '40'
    elif 'CBW80' in f:
        bw = '80'
    
    return band+bw

def run(path):
    for f in path:
        d = "AgcGen_" + get_date() + get_band(f)
        fsm = StateFactory(512, d)
        fsm.run(f)
        agc_debug_file = AgcFilePrinter(d)
        fsm.traverse_all(agc_debug_file)
        print(f"Signature is {hex(int(fsm.gen_signature, 2))}\n")
        print(f"Addr Ram Max is {int(fsm.addr_ram_max, 16)}\n")
        print(f"Number of state is {fsm.state_number}\n")
        print("Successfully generate !!\n")
        print("===========END===========\n\n")
        time.sleep(1)


if __name__ == "__main__":
    error = False
    try:
        run(sys.argv[1:])
    except Exception as e:
        error = True
        print(e)
    if error:
        sys.exit(1)