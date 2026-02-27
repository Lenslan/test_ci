	case 'Begin'
	% 1st state after reset
	nb_trans = 1; cmdEn = 0; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Set4AGCMode';

	case 'Set4Plat'
	% EVENT 0: SAT
	% Increase sat count
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 1 0 0 1 0 0 1 1 0 0 1 1 1 1 ];
	cmd = 91; parameter1 = [0,0,0 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Set4PlatVsSatCount';

	case 'Wait4Plat'
	% EVENT 1: DET
	% stop modem
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 1 0 0 0 0 0 0 0 1 0 1 1 1 1 ];
	cmd = 50; parameter1 = [0,0,0 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SLNACheck';


	case 'Set4Det'
	% EVENT 2: DIS
	% reset post disappearance
	nb_trans = 2; cmdEn = 0; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	op{1,1} = 'radarDet'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'ValidRadarPostDis';
	op{2,1} = 'true'; op{2,2} = 'false'; op{2,3} = 'false'; pathComb{2} = 0; opComb{2} = 0; tgtState{2} = 'Set4DetInitGain';

	case 'DsssDet'
	% EVENT 3: DSSS DET
	% reset detection and saturation blocks
	nb_trans = 2; cmdEn = 0; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 50; dspEn = [1 0 0 0 0 0 0 1 0 0 0 1 1 1 1 ];
	op{1,1} = 'ofdmOnly'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Sleep';
	op{2,1} = 'timeOut'; op{2,2} = 'false'; op{2,3} = 'false'; pathComb{2} = 0; opComb{2} = 0; tgtState{2} = 'Sleep';

	case 'SLNACheck'
	% lna is designed to pulse not a state
	nb_trans = 3; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 1 0 0 0 0 0 0 0 1 0 1 1 1 1 ];
	cmd = 95; parameter1 = [0,0,0 ];
	op{1,1} = 'LNASatDet'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SLNASatACICheck';
	op{2,1} = 'adcPowdBmSup'; op{2,2} = 'true'; op{2,3} = 'inbdPowInf'; pathComb{2} = 1; opComb{2} = 1; tgtState{2} = 'SACIPostDetConf';
	op{3,1} = 'true'; op{3,2} = 'false'; op{3,3} = 'false'; pathComb{3} = 0; opComb{3} = 0; tgtState{3} = 'PostDetConf';


	case 'SLNASatACICheck'
	% check the ACI, back off the gain
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 8; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	cmd = 13; parameter1 = [0,30,33 ];
	op{1,1} = 'timeOut'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SRUMPUP2SAT';

	case 'SRUMPUP2SAT'
	% check the ACI, back off the gain
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	cmd = 91; parameter1 = [0,0,0 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Set4PlatConfPow';

	case 'Set4AGCMode'
	% define the multi-antenna AGC mode
	nb_trans = 2; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 3; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	cmd = 11; parameter1 = [0,0,3 ];
	op{1,1} = 'timeOut'; op{1,2} = 'true'; op{1,3} = 'true'; pathComb{1} = 0; opComb{1} = 1; tgtState{1} = 'Set4DetInitGain';
	op{2,1} = 'rxHETBEn'; op{2,2} = 'true'; op{2,3} = 'true'; pathComb{2} = 0; opComb{2} = 1; tgtState{2} = 'Sleep4HETB';

	case 'Sleep4HETB'
  % wait 14us for hetb
	nb_trans = 1; cmdEn = 0; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 140; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	op{1,1} = 'timeOut'; op{1,2} = 'true'; op{1,3} = 'true'; pathComb{1} = 0; opComb{1} = 1; tgtState{1} = 'Set4DetInitGain';

	case 'Set4DetInitGain'
	% set initial gain to 66dB & wait fixed delay for gain setting
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 3; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	cmd = 12; parameter1 = [0,66,65 ];
	op{1,1} = 'timeOut'; op{1,2} = 'true'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'FullDigReset';

	case 'FullDigReset'
	% reset all blocks (in particular saturation counters)
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	cmd = 1; parameter1 = [0,0,0 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Set4DetResetDSP';

	case 'Set4DetResetDSP'
	% enable adc power estim and inband power estim and wait for conv
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	cmd = 60; parameter1 = [0,0,0];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'ResetADCPowWindow';

	case 'ResetADCPowWindow'
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	cmd = 62; parameter1 = [0,2,0];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'ResetInbdPowWindow';

	case 'ResetInbdPowWindow'
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	cmd = 61; parameter1 = [0,115,163];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Set4ACIDetON';
 
	case 'Set4ACIDetON'
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	cmd = 16; parameter1 = [0,0,9];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Set4DetStartDC';

	case 'Set4DetStartDC'
	% enable dc offset and FE + wait dc convergence
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 4; dspEn = [0 0 0 0 0 0 0 1 0 0 0 0 0 1 1 ];
	cmd = 64; parameter1 = [0,0,1 ];
	op{1,1} = 'timeOut'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Set4DetStartPow';

	case 'Set4DetStartPow'
	% enable adc power estim and inband power estim and wait for conv / define min4sat,min,max gains
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 16; dspEn = [1 1 0 0 0 0 0 1 0 0 0 1 1 1 1 ];
	cmd = 20; parameter1 = [11,35,63 ];
	op{1,1} = 'timeOut'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Sleep';

	case 'Sleep'
	nb_trans = 2; cmdEn = 0; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 50; dspEn = [1 1 0 0 0 0 1 1 0 0 0 1 1 1 1 ];
	op{1,1} = 'OFDMPackDet'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'PostDetConf';
	op{2,1} = 'timeOut'; op{2,2} = 'false'; op{2,3} = 'false'; pathComb{2} = 0; opComb{2} = 0; tgtState{2} = 'CaptureNoiseSleep';

	case 'CaptureNoiseSleep'
	% capture noise into status register
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 0 0 1 1 1 0 0 0 1 1 1 1 ];
	cmd = 65; parameter1 = [0,15,3 ];
	op{1,1} = 'true'; op{1,2} = 'true'; op{1,3} = 'true'; pathComb{1} = 0; opComb{1} = 1; tgtState{1} = 'ClearLNASatSleep';
 
	case 'ClearLNASatSleep'
	nb_trans = 2; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 0 0 1 1 1 0 0 0 1 1 1 1 ];
	cmd = 16; parameter1 = [0,0,9 ];
	op{1,1} = 'OFDMPackDet'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'PostDetConf';
	op{2,1} = 'true'; op{2,2} = 'true'; op{2,3} = 'true'; pathComb{2} = 0; opComb{2} = 1; tgtState{2} = 'Sleep';

	case 'ValidRadarPostDis'
	% from DIS % stop timer
	nb_trans = 4; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	cmd = 73; parameter1 = [0,0,0 ];
	op{1,1} = 'meas2Done'; op{1,2} = 'fomHigh'; op{1,3} = 'lengthLow'; pathComb{1} = 0; opComb{1} = 1; tgtState{1} = 'ValidRadarPostDis_2' ;
	op{2,1} = 'meas1Done'; op{2,2} = 'fomHigh'; op{2,3} = 'lengthLow'; pathComb{2} = 0; opComb{2} = 1; tgtState{2} = 'ValidRadarPostDis_1';
	op{3,1} = 'meas1Done'; op{3,2} = 'fomMed'; op{3,3} = 'lengthLow'; pathComb{3} = 0; opComb{3} = 1; tgtState{3} = 'ValidRadarPostDis_1';
	op{4,1} = 'true'; op{4,2} = 'false'; op{4,3} = 'false'; pathComb{4} = 0; opComb{4} = 0; tgtState{4} = 'ResetRadarPostDis';

	case 'ValidRadarPostDis_1'
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	cmd = 72; parameter1 = [0,1,1 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'ResetRadarPostDis';

	case 'ValidRadarPostDis_2'
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	cmd = 72; parameter1 = [0,2,2 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'ResetRadarPostDis';

	case 'ResetRadarPostDis'
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	cmd = 70; parameter1 = [0,0,0 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Set4DetInitGain';


	case 'Set4PlatVsSatCount'
	% Switch gain vs satcount && Stop demodulation
	nb_trans = 4; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 1 0 0 0 0 0 0 0 0 0 1 1 1 1 ];
	cmd = 50; parameter1 = [0,0,0 ];
	op{1,1} = 'satCount2'; op{1,2} = 'rfGainCp2Min'; op{1,3} = 'true'; pathComb{1} = 0; opComb{1} = 1; tgtState{1} = 'Set4Plat2dSatExtra';
	op{2,1} = 'satCount2'; op{2,2} = 'satCount3'; op{2,3} = 'satCount4'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Set4Plat2dSat';
	op{3,1} = 'satCount1'; op{3,2} = 'radarDet'; op{3,3} = 'adcPowdBmRad'; pathComb{2} = 0; opComb{2} = 1; tgtState{2} = 'RadTimerPreOn';
	op{4,1} = 'satCount1'; op{4,2} = 'false'; op{4,3} = 'false'; pathComb{3} = 0; opComb{3} = 0; tgtState{3} = 'Set4Plat1rstSat';

	case 'RadTimerPreOn'
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 1 0 0 0 0 0 0 0 0 0 1 1 1 1 ];
	cmd = 73; parameter1 = [0,0,0];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} =  'RadTimerOn';

	case 'RadTimerOn'
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 1 0 0 0 0 0 0 0 0 0 1 1 1 1 ];
	cmd = 73; parameter1 = [0,0,1 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'RadMeas1';

	case 'RadMeas1'
	% Launch FIFO processing
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 1 0 0 0 0 0 0 0 0 0 1 1 1 1 ];
	cmd = 71; parameter1 = [0,0,0 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Set4Plat1rstSat';

	case 'Set4Plat1rstSat'
	% Reduce gain after 1rst saturation by 30dB targeting 36dB by default
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 4; dspEn = [0 1 0 0 0 0 0 0 0 0 0 0 1 0 0 ];
	cmd = 13; parameter1 = [0,30,33 ];
	op{1,1} = 'timeOut'; op{1,2} = 'true'; op{1,3} = 'true'; pathComb{1} = 0; opComb{1} = 1; tgtState{1} = 'AfeClear1rstSat';
	
	case 'AfeClear1rstSat'
	nb_trans = 1; cmdEn = 0; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	op{1,1} = 'true'; op{1,2} = 'true'; op{1,3} = 'true'; pathComb{1} = 0; opComb{1} = 1; tgtState{1} = 'Set4PlatConfPow';

	case 'SSet4Plat1rstSatCloseFE'
	nb_trans = 1; cmdEn = 0; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 5; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	op{1,1} = 'timeOut'; op{1,2} = 'true'; op{1,3} = 'true'; pathComb{1} = 0; opComb{1} = 1; tgtState{1} = 'Set4PlatConfPow';

	case 'Set4PlatConfPow'
	% Configure in-band power estimator
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	cmd = 61; parameter1 = [0,113,161 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Set4PlatConfPow2';

	case 'Set4PlatConfPow2'
	% Configure adc power estimator
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	cmd = 62; parameter1 = [0,1,0 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'PostSatEnPow';

	case 'Set4Plat2dSat'
	% Reduce gain after 2d saturation to 10dB
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 6; dspEn = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	cmd = 13; parameter1 = [0,29,33 ];
	op{1,1} = 'true'; op{1,2} = 'timeOut'; op{1,3} = 'true'; pathComb{1} = 0; opComb{1} = 1; tgtState{1} = 'Post2dSatWait';

	case 'Set4Plat2dSatExtra'
	% Reduce gain after 2d saturation to 10dB
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 11; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	cmd = 13; parameter1 = [0,44,33 ];
	op{1,1} = 'true'; op{1,2} = 'timeOut'; op{1,3} = 'true'; pathComb{1} = 0; opComb{1} = 1; tgtState{1} = 'PostSatEnPow';
	case 'Set4Plat3dSat'
	% Reduce gain after 3rd or 4th saturation to 0dB
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 7; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	cmd = 13; parameter1 = [0,15,33 ];
	op{1,1} = 'true'; op{1,2} = 'timeOut'; op{1,3} = 'true'; pathComb{1} = 0; opComb{1} = 1; tgtState{1} = 'PostSatEnPow';

	case 'Post2dSatWait'
	% Reduce gain after 2d saturation to 10dB
	nb_trans = 1; cmdEn = 0; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 1; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	op{1,1} = 'true'; op{1,2} = 'timeOut'; op{1,3} = 'true'; pathComb{1} = 0; opComb{1} = 1; tgtState{1} = 'PostSatEnPow';
	
	case 'PostSatEnPow'
	% enable OFDM FE, release RIFS detected after any saturation
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 7; dspEn = [0 0 0 0 0 0 0 1 0 0 0 0 1 1 1 ];
	cmd = 52; parameter1 = [0,0,0 ];
	op{1,1} = 'timeOut'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'PostSatEnPow2';

	case 'PostSatEnPow2'
	% adc power estim and inband power estim and correlator / clear Ctrlflag
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 2; dspEn = [0 0 0 0 0 0 0 1 0 1 0 1 1 1 1 ];
	cmd = 38; parameter1 = [0,0,0 ];
	op{1,1} = 'timeOut'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'WaitPostSat';

	case 'WaitPostSat'
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 0 0 0 1 0 0 1 0 1 0 1 1 1 1 ];
	cmd = 31; parameter1 = [25,16,16 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'PostSatEnCor';

	case 'PostSatEnCor'
	% enable correlator detector
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 0 0 0 1 0 0 1 0 1 0 1 1 1 1 ];
	cmd = 80; parameter1 = [0,0,0 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'PlatSearchSel';

	case 'PlatSearchSel'
	% define plateau detection mode vs satcount
	nb_trans = 3; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 0 0 0 1 0 0 0 0 1 0 1 1 1 1 ];
	cmd = 95; parameter1 = [0,0,0 ];
	op{1,1} = 'satCount3'; op{1,2} = 'satCount4'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Wait4PlatPostSat2';
	op{2,1} = 'satCount2'; op{2,2} = 'false'; op{2,3} = 'false'; pathComb{2} = 0; opComb{2} = 0; tgtState{2} = 'Wait4PlatPostSat2';
	op{3,1} = 'satCount1'; op{3,2} = 'false'; op{3,3} = 'false'; pathComb{3} = 0; opComb{3} = 0; tgtState{3} = 'Wait4PlatPostSat1';

	case 'Wait4PlatPostSat1'
	nb_trans = 1; cmdEn = 0; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 8; dspEn = [0 0 0 1 1 0 0 0 0 1 0 1 1 1 1 ];
	op{1,1} = 'timeOut'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'CSFlag1';

	case 'Wait4PlatPostSat2'
	% plateau detection after 2 saturations
	nb_trans = 1; cmdEn = 0; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 5; dspEn = [0 0 0 1 1 0 0 0 0 1 0 1 1 1 1 ];
	op{1,1} = 'timeOut'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'CSFlag1';


	case 'PostDetConf'
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 2; dspEn = [1 1 0 0 1 0 0 0 0 1 0 1 1 1 1 ];
	cmd = 31; parameter1 = [25,25,16 ];
	op{1,1} = 'timeOut'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'PostDetCorEn';


	case 'SACIPostDetConf'
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 3; dspEn = [1 1 0 0 1 1 0 1 0 1 0 1 1 1 1 ];
	cmd = 31; parameter1 = [25,25,16 ];
	op{1,1} = 'timeOut'; op{1,2} = 'stablePow'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SACIPostDetConf2';

	case 'SACIPostDetConf2'
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 2; dspEn = [1 1 0 0 1 1 0 1 0 1 0 1 1 1 1 ];
	cmd = 38; parameter1 = [0,0,0 ];
	op{1,1} = 'timeOut'; op{1,2} = 'stablePow'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'CSFlag1';

	case 'PostDetCorEn'
	% enable correlator detector
	nb_trans = 1; cmdEn = 0; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 3; dspEn = [1 1 0 1 1 0 0 0 0 1 0 1 1 1 1 ];
	op{1,1} = 'timeOut'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Wait4PlatPostDet';

	case 'Wait4PlatPostDet'
	% plateau detection when no saturation occured / clear Ctrlflag
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 2; dspEn = [1 1 0 1 1 0 0 0 0 1 0 1 1 1 1 ];
	cmd = 38; parameter1 = [0,0,0 ];
	op{1,1} = 'timeOut'; op{1,2} = 'stablePow'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'CSFlag1';

	case 'CSFlag1'
	% Define CS flag 1
	nb_trans = 4; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 1 1 0 0 0 0 1 0 1 1 1 1 ];
	cmd = 35; parameter1 = [-52,40,-100 ];
	op{1,1} = 'ofdmAC'; op{1,2} = 'ofdmCC'; op{1,3} = 'rxHETBEn'; pathComb{1} = 0; opComb{1} = 3; tgtState{1} = 'CSFlag1OfdmHigh';
	op{2,1} = 'ofdmAC'; op{2,2} = 'true'; op{2,3} = 'true'; pathComb{2} = 0; opComb{2} = 1; tgtState{2} = 'CSFlag1OfdmLow';
	op{3,1} = 'ofdmCC'; op{3,2} = 'true'; op{3,3} = 'true'; pathComb{3} = 0; opComb{3} = 1; tgtState{3} = 'CSFlag1OfdmLow';
	op{4,1} = 'true'; op{4,2} = 'true'; op{4,3} = 'true'; pathComb{4} = 0; opComb{4} = 1; tgtState{4} = 'CSFlag1NoOfdm';

	case 'CSFlag1OfdmHigh'
	% Send CS flag 1 - OFDM high confidence
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 1 1 0 0 0 0 1 0 1 1 1 1 ];
	cmd = 41; parameter1 = [0,3,0 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Set4Demod';

	case 'CSFlag1OfdmLow'
	% Send CS flag 1 - OFDM low confidence
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 1 1 0 0 0 0 1 0 1 1 1 1 ];
	cmd = 41; parameter1 = [0,1,0 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Set4Demod';

	case 'CSFlag1NoOfdm'
	% Send CS flag 1 - no OFDM confidence
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 1 1 0 0 0 0 1 0 1 1 1 1 ];
	cmd = 41; parameter1 = [0,0,0 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Set4Demod';

	case 'Set4Demod'
	% Check RIFS before setting gains for demodulation
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 1 1 0 0 0 0 1 0 1 1 1 1 ];
	cmd = 16; parameter1 = [0,0,10 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Set4Demod2';

	case 'Set4Demod2'
	% Check RIFS before setting gains for demodulation
	nb_trans = 4; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 2; dspEn = [1 1 0 1 1 0 0 0 0 1 0 1 1 1 1 ];
	cmd = 66; parameter1 = [0,0,0 ];
	op{1,1} = 'satCount1'; op{1,2} = 'satCount2'; op{1,3} = 'inbdPowInf'; pathComb{1} = 1; opComb{1} = 2; tgtState{1} = 'SACISetOptGain';
	op{2,1} = 'true'; op{2,2} = 'false'; op{2,3} = 'inbdPowInf'; pathComb{2} = 1; opComb{2} = 2; tgtState{2} = 'SACISetOptGain';
	op{3,1} = 'LNASatDet'; op{3,2} = 'false'; op{3,3} = 'false'; pathComb{3} = 0; opComb{3} = 0; tgtState{3} = 'SSet4DemodGainLNASat';
	op{4,1} = 'timeOut'; op{4,2} = 'false'; op{4,3} = 'false'; pathComb{4} = 0; opComb{4} = 0; tgtState{4} = 'SInbdPowdBmSave';

	case 'SACISetOptGain'
	% only set RF gain
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 7; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	cmd = 14; parameter1 = [-20,-22,135 ];
	op{1,1} = 'timeOut'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SACISetOptGainIndPlus';

	case 'SACISetOptGainIndPlus'
	% only set RF gain
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 3; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	cmd = 96; parameter1 = [0,0,0 ];
	op{1,1} = 'timeOut'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SACIDemodFEEn';

	case 'SSet4DemodGainLNASat'
	% Set optimal analog and digital gains 4 demodulation
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 10; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	cmd = 14; parameter1 = [-20,-24,167 ];
	op{1,1} = 'timeOut'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'DemodFEEn';


	case 'SInbdPowdBmSave'
	% Set optimal analog and digital gains 4 demodulation
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 1 1 0 0 0 0 1 0 1 1 1 1 ];
	cmd = 66; parameter1 = [0,0,0 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Set4DemodGain';


	case 'Set4DemodGain'
	% Set optimal analog and digital gains 4 demodulation
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 6; dspEn = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	cmd = 14; parameter1 = [-20,-22,135 ];
	op{1,1} = 'timeOut'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'DemodFEEn';

	case 'SACIDemodFEEn'
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	cmd = 61; parameter1 = [0,113,161 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SACIDemodResetInbdWindow';
 
	case 'SACIDemodResetInbdWindow'
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 6; dspEn = [1 0 0 0 0 0 0 1 0 0 0 0 1 1 1 ];
	cmd = 62; parameter1 = [0,1,0 ];
	op{1,1} = 'timeOut'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SACIOFDMon';

	case 'SACIOFDMon'
	% enable OFDM modem in 20x20
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 0 0 0 0 0 0 0 0 1 1 1 1 ];
	cmd = 50; parameter1 = [0,0,1 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SACILaunchCorr';

	case 'SACILaunchCorr'
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 13; dspEn = [1 1 0 0 0 0 0 1 1 1 0 1 1 1 1 ] ;
	cmd = 31; parameter1 = [16,32,16 ];
	op{1,1} = 'timeOut'; op{1,2} = 'stablePow'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SACILaunchDet';
 
	case 'SACILaunchDet'
	nb_trans = 4; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 64; dspEn = [1 1 0 1 0 0 0 1 1 1 0 1 1 1 1 ];
	cmd = 34; parameter1 = [0,48,-100 ];
	op{1,1} = 'OFDMPacVerify'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SOFDMDet';
	op{2,1} = 'radarDet'; op{2,2} = 'fomMed'; op{2,3} = 'true'; pathComb{2} = 0; opComb{2} = 1; tgtState{2} = 'RadarPulseEval';
	op{3,1} = 'false'; op{3,2} = 'false'; op{3,3} = 'idPow'; pathComb{3} = 0; opComb{3} = 4; tgtState{3} = 'Wait4Plat';
	op{4,1} = 'timeOut'; op{4,2} = 'false'; op{4,3} = 'false'; pathComb{4} = 0; opComb{4} = 0; tgtState{4} = 'RecoverDet4HETB';

    case 'RecoverDet4HETB'
    nb_trans = 2; cmdEn = 0; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 1 0 1 0 1 1 1 0 1 1 1 1 ];
    op{1,1} = 'RxTdmaEn'; op{1,2} = 'rxHETBEn'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SOFDMDet';
    op{2,1} = 'true'; op{2,2} = 'false'; op{2,3} = 'false'; pathComb{2} = 0; opComb{2} = 0; tgtState{2} = 'SAbnormalOfdmStoreINBDPower';

	case 'DemodFEEn'
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 8; dspEn = [1 0 0 0 0 0 0 0 0 0 0 0 1 1 1 ];
	cmd = 62; parameter1 = [0,1,0 ];
	op{1,1} = 'timeOut'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'OFDMon';

	case 'OFDMon'
	% enable OFDM modem in 20x20
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 0 0 0 0 0 0 0 0 0 1 1 1 ];
	cmd = 50; parameter1 = [0,0,1 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'DemConfPow';

	case 'DemConfPow'
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 0 0 0 0 0 0 0 0 0 1 1 1 ];
	cmd = 61; parameter1 = [51,113,225 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'DemConfCorr';

	case 'DemConfCorr'
	% Configure correlators for differentiation
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 0 0 0 0 0 0 0 0 0 1 1 1 ];
	cmd = 63; parameter1 = [0,1,0 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'LaunchCorr';

	case 'LaunchCorr'
	% enable ofdm & DSSS correlator + wait for ofdm correlator convergence
	% Configure correlation detector
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 13; dspEn = [1 1 0 0 0 1 0 0 1 1 0 1 1 1 1 ] ;
	cmd = 31; parameter1 = [16,32,16 ];
	op{1,1} = 'timeOut'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'LaunchDet';

	case 'LaunchDet'
	% enable correlator detector
	% disable cross-up detection
	nb_trans = 4; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 64; dspEn = [1 1 0 1 0 1 0 0 1 1 0 1 1 1 1 ];
	cmd = 34; parameter1 = [0,48,-100 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'inbdPowInf'; pathComb{1} = 1; opComb{1} = 2; tgtState{1} = 'SACILaunchDet';
	op{2,1} = 'OFDMPacVerify'; op{2,2} = 'false'; op{2,3} = 'false'; pathComb{2} = 0; opComb{2} = 0; tgtState{2} = 'SOFDMDet';
	op{3,1} = 'false'; op{3,2} = 'false'; op{3,3} = 'idPow'; pathComb{3} = 0; opComb{3} = 4; tgtState{3} = 'Wait4Plat';
	op{4,1} = 'timeOut'; op{4,2} = 'false'; op{4,3} = 'false'; pathComb{4} = 0; opComb{4} = 0; tgtState{4} = 'RecoverDet4HETB';

	case 'SOFDMDet'
	% OFDM has been verified after AGC, adjust timeOutVal from 8 to 6, this value should be modified according to parameters of cmd63
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 2; dspEn = [1 1 0 1 0 1 0 0 1 1 0 1 1 1 1 ];
	cmd = 35; parameter1 = [-60,48,-100 ];
	op{1,1} = 'timeOut'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SOFDMInbdCheck';
 
	case 'SOFDMInbdCheck'
	nb_trans = 2; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 3; dspEn = [1 1 0 1 0 1 0 0 1 1 0 1 1 1 1 ];
	cmd = 95; parameter1 = [0,0,0 ];
	op{1,1} = 'satCount1'; op{1,2} = 'satCount2'; op{1,3} = 'inbdPowInf'; pathComb{1} = 1; opComb{1} = 2; tgtState{1} = 'SAbnormalOfdmStoreINBDPower';
	op{2,1} = 'timeOut'; op{2,2} = 'false'; op{2,3} = 'false'; pathComb{2} = 0; opComb{2} = 0; tgtState{2} = 'SLegacyStoreINBDPower';

	case 'SLegacyStoreINBDPower'
	% OFDM has been verified after AGC
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 1 0 1 0 0 1 1 0 1 1 1 1 ];
	cmd = 65; parameter1 = [0,0,3 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'StoreInbd';

	case 'StoreInbd'
	% Compute in-band power for noise variance and SNR evaluation by modem core
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 1 0 1 1 0 1 1 0 1 1 1 1 ];
	cmd = 12; parameter1 = [0,0,4 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'FixedCorr';

	case 'FixedCorr'
	% maintain ofdm correlator detector output to be compared with DSSS
	% correlation results
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 1 0 0 0 0 1 1 0 1 1 1 1 ];
	cmd = 33; parameter1 = [0,0,3 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'CSFlag2';

	case 'CSFlag2'
	% Define CS flag 2
	nb_trans = 5; cmdEn = 0; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 1 0 0 0 0 1 1 0 1 1 1 1 ];
	op{1,1} = 'ofdmAC'; op{1,2} = 'ofdmCC'; op{1,3} = 'rxHETBEn'; pathComb{1} = 0; opComb{1} = 3; tgtState{1} = 'CSFlag2OfdmHigh';
	op{2,1} = 'ofdmAC'; op{2,2} = 'true'; op{2,3} = 'true'; pathComb{2} = 0; opComb{2} = 1; tgtState{2} = 'CSFlag2OfdmLow';
	op{3,1} = 'ofdmCC'; op{3,2} = 'true'; op{3,3} = 'true'; pathComb{3} = 0; opComb{3} = 1; tgtState{3} = 'CSFlag2OfdmLow';
	op{4,1} = 'ofdmOnly'; op{4,2} = 'true'; op{4,3} = 'true'; pathComb{4} = 0; opComb{4} = 1; tgtState{4} = 'CSFlag2OfdmNo';
	op{5,1} = 'true'; op{5,2} = 'true'; op{5,3} = 'true'; pathComb{5} = 0; opComb{5} = 1; tgtState{5} = 'CSFlag2OfdmNo';

	case 'CSFlag2OfdmHigh'
	% Send CS flag 2 - OFDM high confidence
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 1 1 0 0 0 1 1 0 1 1 1 1 ];
	cmd = 41; parameter1 = [0,3,1 ];
	op{1,1} = 'true'; op{1,2} = 'rxHETBEn'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SWait4SYNC';

	case 'CSFlag2OfdmLow'
	% Send CS flag 2 - OFDM low confidence
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 1 1 0 0 0 1 1 0 1 1 1 1 ];
	cmd = 41; parameter1 = [0,1,1 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SWait4SYNC';

	case 'CSFlag2OfdmNo'
	% Send CS flag 2 - no OFDM high confidence
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 1 1 0 0 0 1 1 0 1 1 1 1 ];
	cmd = 41; parameter1 = [0,0,1 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SAbnormalOfdmStoreINBDPower';


	case 'SAbnormalOfdmStoreINBDPower'
	% before ofdm off, store inbd signal power
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 2; dspEn = [1 1 0 1 0 0 0 0 1 1 0 1 1 1 1 ];
	cmd = 65; parameter1 = [0,0,3 ];
	op{1,1} = 'timeOut'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SAbnormalOfdmOff';


	case 'SAbnormalOfdmOff'
	% Stop OFDM demodulation
	% By franklin directly go back to Set4DetInitGain, merge from WiFi5
	nb_trans = 2; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 1 1 0 0 0 1 1 0 1 1 1 1 ];
	cmd = 50; parameter1 = [0,0,0 ];
	op{1,1} = 'radarDet'; op{1,2} = 'fomMed'; op{1,3} = 'true'; pathComb{1} = 0; opComb{1} = 1; tgtState{1} = 'RadarPulseEval';
	op{2,1} = 'true'; op{2,2} = 'false'; op{2,3} = 'false'; pathComb{2} = 0; opComb{2} = 0; tgtState{2} = 'SErrorResetSatCount';

	case 'SErrorResetSatCount'
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 2; dspEn = [1 1 0 1 1 0 0 0 1 1 0 1 1 1 1 ];
	cmd = 90; parameter1 = [0,0,0 ];
	op{1,1} = 'timeOut'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SErrorPowHold';

	case 'SErrorPowHold'
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 1 1 0 0 1 1 1 0 1 1 1 1 ];
	cmd = 35; parameter1 = [-52,56,-100 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SErrorPowHoldRstRamp';

	case 'SErrorPowHoldRstRamp'
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 1 1 0 1 1 1 1 0 1 1 1 1 ];
	cmd = 34; parameter1 = [0,32,-100 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SErrorPowHoldRstInbdSWL';

	case 'SErrorPowHoldRstInbdSWL'
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 1 1 0 1 1 1 1 0 1 1 1 1 ];
	cmd = 61; parameter1 = [0,115,163];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SErrorPowHold2';


	case 'SErrorPowHold2'
	nb_trans = 2; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 600; dspEn = [1 1 0 1 1 0 1 1 1 1 0 1 1 1 1 ];
	cmd = 95; parameter1 = [0,0,0 ];
	op{1,1} = 'OFDMPackDet'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'PostDetConf';
	op{2,1} = 'rampDn'; op{2,2} = 'timeOut'; op{2,3} = 'false'; pathComb{2} = 0; opComb{2} = 0; tgtState{2} = 'Set4DetInitGain';

	case 'MdmOff'
	% Switch OFDM modem off
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 0 0 0 0 1 1 0 0 0 0 1 1 1 1 ];
	cmd = 50; parameter1 = [0,0,0 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Set4DetInitGain';


	case 'RadarPulseEval'
	nb_trans = 3; cmdEn = 0; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 10; dspEn = [1 1 0 0 0 1 1 1 0 0 0 1 1 1 1 ];
	op{1,1} = 'radarDet'; op{1,2} = 'meas2Done'; op{1,3} = 'true'; pathComb{1} = 0; opComb{1} = 1; tgtState{1} = 'RadMeas2Check';
	op{2,1} = 'radarDet'; op{2,2} = 'meas1Done'; op{2,3} = 'true'; pathComb{2} = 0; opComb{2} = 1; tgtState{2} = 'RadMeas1Check';
	op{3,1} = 'timeOut'; op{3,2} = 'false'; op{3,3} = 'false'; pathComb{3} = 0; opComb{3} = 0; tgtState{3} = 'Set4DetInitGain';

	case 'RadMeas1Check'
	% Check radar detector outputs
	nb_trans = 3; cmdEn = 0; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 0 0 1 1 1 0 0 0 1 1 1 1 ];
	op{1,1} = 'fomMed'; op{1,2} = 'adcPowdBmRad'; op{1,3} = 'true'; pathComb{1} = 0; opComb{1} = 1; tgtState{1} = 'WaitRadMeas2';
	op{2,1} = 'fomMed'; op{2,2} = 'false'; op{2,3} = 'false'; pathComb{2} = 0; opComb{2} = 0; tgtState{2} = 'ValidRadar';
	op{3,1} = 'true'; op{3,2} = 'false'; op{3,3} = 'false';pathComb{3} = 0; opComb{3} = 0; tgtState{3} = 'ResetRadar';

	case 'WaitRadMeas2'
	% wait before doing a 2d measurement - to reduce false alarms
	nb_trans = 1; cmdEn = 0; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 50; dspEn = [1 1 0 0 0 1 1 1 0 0 0 1 1 1 1 ];
	op{1,1} = 'timeOut'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'ConfirmRadMeas2';

	case 'ConfirmRadMeas2'
	% Check if second measurement is required depending on adc power
	nb_trans = 2; cmdEn = 0; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 0 0 1 1 1 0 0 0 1 1 1 1 ];
	op{1,1} = 'adcPowdBmRad'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'RadMeas2';
	op{2,1} = 'true'; op{2,2} = 'false'; op{2,3} = 'false';pathComb{2} = 0; opComb{2} = 0; tgtState{2} = 'ValidRadar';

	case 'RadMeas2'
	% Launch RADAR FIFO processing i.e. compute FOM
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 0 0 1 1 1 0 0 0 1 1 1 1 ];
	cmd = 71; parameter1 = [0,0,3 ];
	op{1,1} = 'meas2Done'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'RadMeas2Check';

	case 'RadMeas2Check'
	% Check radar detector outputs
	nb_trans = 3; cmdEn = 0; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 0 0 1 1 1 0 0 0 1 1 1 1 ];
	op{1,1} = 'fomHigh'; op{1,2} = 'adcPowdBmRad'; op{1,3} = 'true'; pathComb{1} = 0; opComb{1} = 1; tgtState{1} = 'Wait4PulseEnd';
	op{2,1} = 'fomHigh'; op{2,2} = 'false'; op{2,3} = 'false'; pathComb{2} = 0; opComb{2} = 0; tgtState{2} = 'ValidRadar';
	op{3,1} = 'true'; op{3,2} = 'false'; op{3,3} = 'false';pathComb{3} = 0; opComb{3} = 0; tgtState{3} = 'ResetRadar';

	case 'Wait4PulseEnd'
	% Increase ramp-up detection gap to prevent false detection (in
	% particular at the end of the radar pulse)
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 0 0 1 1 1 0 0 0 1 1 1 1 ];
	cmd = 34; parameter1 = [0,32,-100 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Wait4PulseEnd2';

	case 'Wait4PulseEnd2'
	% wait for end of radar pulse / max pulse length 100us
	nb_trans = 2; cmdEn = 0; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 1000; dspEn = [1 1 0 0 0 1 1 1 0 0 0 1 1 1 1 ];
	op{1,1} = 'true'; op{1,2} = 'radarDet'; op{1,3} = 'adcPowdBmRad'; pathComb{1} = 0; opComb{1} = 5; tgtState{1} = 'ValidRadarPostDis';
	op{2,1} = 'timeOut'; op{2,2} = 'false'; op{2,3} = 'false'; pathComb{2} = 0; opComb{2} = 0; tgtState{2} = 'ValidRadar';

	case 'ValidRadar'
	% stop radar timer
	% Check radar detector outputs and decide if the pulse is a radar or not
	nb_trans = 4; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 0 0 1 1 1 0 0 0 1 1 1 1 ];
	cmd = 73; parameter1 = [0,0,0 ];
	op{1,1} = 'meas2Done'; op{1,2} = 'fomHigh'; op{1,3} = 'lengthLow'; pathComb{1} = 0; opComb{1} = 1; tgtState{1} = 'ValidRadar_2' ;
	op{2,1} = 'meas1Done'; op{2,2} = 'fomHigh'; op{2,3} = 'lengthLow'; pathComb{2} = 0; opComb{2} = 1; tgtState{2} = 'ValidRadar_1';
	op{3,1} = 'meas1Done'; op{3,2} = 'fomMed'; op{3,3} = 'lengthLow'; pathComb{3} = 0; opComb{3} = 1; tgtState{3} = 'ValidRadar_1';
	op{4,1} = 'true'; op{4,2} = 'false'; op{4,3} = 'false'; pathComb{4} = 0; opComb{4} = 0; tgtState{4} = 'ResetRadar';

	case 'ValidRadar_1'
	% Send command to store detected pulse
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 0 0 1 1 1 0 0 0 1 1 1 1 ];
	cmd = 72; parameter1 = [0,1,1 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'ResetRadar';

	case 'ValidRadar_2'
	% Send command to store detected pulse
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 0 0 1 1 1 0 0 0 1 1 1 1 ];
	cmd = 72; parameter1 = [0,2,2 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'ResetRadar';

	case 'ResetRadar'
	% Send command to reset radar detector
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 0 0 1 1 1 0 0 0 1 1 1 1 ];
	cmd = 70; parameter1 = [0,0,0 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Set4DetInitGain';

	case 'SIGRadarPulseEval'
	nb_trans = 2; cmdEn = 0; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 10; dspEn = [1 1 0 0 0 1 1 1 0 0 0 1 1 1 1 ];
	op{1,1} = 'radarDet'; op{1,2} = 'meas1Done'; op{1,3} = 'true'; pathComb{1} = 0; opComb{1} = 1; tgtState{1} = 'SIGRadMeas1Check';
	op{2,1} = 'timeOut'; op{2,2} = 'false'; op{2,3} = 'false'; pathComb{2} = 0; opComb{2} = 0; tgtState{2} = 'Wait4SIG2';

	case 'SIGRadMeas1Check'
	% Check radar detector outputs
	nb_trans = 3; cmdEn = 0; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 0 0 1 1 0 0 0 0 1 1 1 1 ];
	op{1,1} = 'fomMed'; op{1,2} = 'adcPowdBmRad'; op{1,3} = 'true'; pathComb{1} = 0; opComb{1} = 1; tgtState{1} = 'SIGWaitRadMeas2';
	op{2,1} = 'fomHigh'; op{2,2} = 'false'; op{2,3} = 'false'; pathComb{2} = 0; opComb{2} = 0; tgtState{2} = 'SIGValidRadar';
	op{3,1} = 'true'; op{3,2} = 'false'; op{3,3} = 'false';pathComb{3} = 0; opComb{3} = 0; tgtState{3} = 'SIGResetRadar';

	case 'SIGValidRadar'
	% stop timer
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 0 0 1 1 0 0 0 0 1 1 1 1 ];
	cmd = 73; parameter1 = [0,0,0 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SIGValidRadar2' ;

	case 'SIGValidRadar2'
	% stop timer
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 0 0 1 1 0 0 0 0 1 1 1 1 ];
	cmd = 72; parameter1 = [0,1,1 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Set4DetInitGain';

	case 'SIGResetRadar'
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 0 0 1 1 0 0 0 0 1 1 1 1 ];
	cmd = 70; parameter1 = [0,0,0 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Wait4SIG2';

	case 'SIGWaitRadMeas2'
	% wait before 2d measurement
	nb_trans = 1; cmdEn = 0; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 50; dspEn = [1 1 0 0 0 1 1 0 0 0 0 1 1 1 1 ];
	op{1,1} = 'timeOut'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SIGConfirmRadMeas2';

	case 'SIGConfirmRadMeas2'
	% wait for before 2d measurement
	nb_trans = 2; cmdEn = 0; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 0 0 1 1 0 0 0 0 1 1 1 1 ];
	op{1,1} = 'adcPowdBmRad'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SIGRadMeas2';
	op{2,1} = 'true'; op{2,2} = 'false'; op{2,3} = 'false';pathComb{2} = 0; opComb{2} = 0; tgtState{2} = 'SIGValidRadar';

	case 'SIGRadMeas2'
	% Launch FIFO processing
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 0 0 1 1 0 0 0 0 1 1 1 1 ];
	cmd = 71; parameter1 = [0,0,4 ];
	op{1,1} = 'meas2Done'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SIGRadMeas2Check';

	case 'SIGRadMeas2Check'
	% Check radar detector outputs
	nb_trans = 2; cmdEn = 0; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 0 0 1 1 0 0 0 0 1 1 1 1 ];
	op{1,1} = 'fomHigh'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Wait4SIG2';
	op{2,1} = 'true'; op{2,2} = 'false'; op{2,3} = 'false';pathComb{2} = 0; opComb{2} = 0; tgtState{2} = 'SIGResetRadar';

	case 'SWait4SYNC'
	nb_trans = 3; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 0 0 0 1 1 0 0 0 1 1 1 1 ];
	cmd = 52; parameter1 = [0,0,0 ];
	op{1,1} = 'radarDet'; op{1,2} = 'fomMed'; op{1,3} = 'true'; pathComb{1} = 0; opComb{1} = 1; tgtState{1} = 'SIGRadarPulseEval';
	op{2,1} = 'cmdCtrlFlag'; op{2,2} = 'false'; op{2,3} = 'false'; pathComb{2} = 0; opComb{2} = 0; tgtState{2} = 'Set4DetInitGain';
	op{3,1} = 'true'; op{3,2} = 'false'; op{3,3} = 'false'; pathComb{3} = 0; opComb{3} = 0; tgtState{3} = 'SWait4SYNC2';


	case 'SWait4SYNC2'
	nb_trans = 3; cmdEn = 0; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 340; dspEn = [0 1 0 0 0 0 1 1 0 0 0 1 1 1 1 ];
	op{1,1} = 'RxTdmaEn'; op{1,2} = 'rxHETBEn'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Wait4SIG2';
	op{2,1} = 'LTFSYNC'; op{2,2} = 'false'; op{2,3} = 'false'; pathComb{2} = 0; opComb{2} = 0; tgtState{2} = 'Wait4SIG2';
	op{3,1} = 'timeOut'; op{3,2} = 'false'; op{3,3} = 'false'; pathComb{3} = 0; opComb{3} = 0; tgtState{3} = 'SAbnormalOfdmStoreINBDPower';

	case 'Wait4SIG2'
	% Wait 4 L-SIG / HT-SIG decoding
	nb_trans = 3; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 500; dspEn = [0 1 0 0 0 0 1 0 0 0 0 1 1 1 1 ];
	cmd = 65; parameter1 = [0,0,31 ];
	op{1,1} = 'validLSIG'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Wait4HTSTF';
	op{2,1} = 'timeOut'; op{2,2} = 'false'; op{2,3} = 'demodRun'; pathComb{2} = 0; opComb{2} = 4; tgtState{2} = 'SAbnormalOfdmStoreINBDPower';
	op{3,1} = 'validHTSIG'; op{3,2} = 'true'; op{3,3} = 'true'; pathComb{3} = 0; opComb{3} = 1; tgtState{3} = 'PreWait4RxEnd';

	case 'Wait4HTSTF'
	nb_trans = 4; cmdEn = 0; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 1400; dspEn = [0 1 0 0 1 1 1 0 0 0 0 1 1 1 1 ];
	op{1,1} = 'htstfStEst'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'HTSTFPowReset';
	op{2,1} = 'timeOut'; op{2,2} = 'true'; op{2,3} = 'true'; pathComb{2} = 0; opComb{2} = 1; tgtState{2} = 'SWait4ShortRxEnd';
	op{3,1} = 'rxEnd4Timing'; op{3,2} = 'true'; op{3,3} = 'true'; pathComb{3} = 0; opComb{3} = 1; tgtState{3} = 'ShortLRxEnd';
	op{4,1} = 'false'; op{4,2} = 'rampDn'; op{4,3} = 'demodRun'; pathComb{4} = 0; opComb{4} = 4; tgtState{4} = 'SAbnormalOfdmStoreINBDPower';

	case 'SWait4ShortRxEnd'
	nb_trans = 3; cmdEn = 0; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 700; dspEn = [0 1 0 0 1 1 1 0 0 0 0 1 1 1 1 ];
	op{1,1} = 'rxEnd4Timing'; op{1,2} = 'true'; op{1,3} = 'true'; pathComb{1} = 0; opComb{1} = 1; tgtState{1} = 'ShortLRxEnd';
	op{2,1} = 'false'; op{2,2} = 'rampDn'; op{2,3} = 'demodRun'; pathComb{2} = 0; opComb{2} = 4; tgtState{2} = 'SAbnormalOfdmStoreINBDPower';
	op{3,1} = 'timeOut'; op{3,2} = 'true'; op{3,3} = 'true'; pathComb{3} = 0; opComb{3} = 1; tgtState{3} = 'Wait4LRxEnd';

	case 'Wait4LRxEnd'
	% clean CCA flag
	nb_trans = 2; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 1 0 0 1 1 1 0 0 0 0 1 1 1 1 ];
	cmd = 41; parameter1 = [0,0,0 ];
	op{1,1} = 'rxEnd4Timing'; op{1,2} = 'true'; op{1,3} = 'true'; pathComb{1} = 0; opComb{1} = 1; tgtState{1} = 'Check4RIFS';
	op{2,1} = 'false'; op{2,2} = 'rampDn'; op{2,3} = 'demodRun'; pathComb{2} = 0; opComb{2} = 4; tgtState{2} = 'SAbnormalOfdmStoreINBDPower';

	case 'ShortLRxEnd'
	% clean CCA flag
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 1 0 0 0 0 0 0 0 0 0 1 1 1 1 ];
	cmd = 41; parameter1 = [0,0,0 ];
	op{1,1} = 'true'; op{1,2} = 'true'; op{1,3} = 'true'; pathComb{1} = 0; opComb{1} = 1; tgtState{1} = 'Check4RIFS';

	case 'HTSTFPowReset'
	% reset power estimator
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 1; dspEn = [0 1 0 0 0 0 0 0 0 0 0 0 1 1 1 ];
	cmd = 61; parameter1 = [17,115,163 ];
	op{1,1} = 'timeOut'; op{1,2} = 'true'; op{1,3} = 'true'; pathComb{1} = 0; opComb{1} = 1; tgtState{1} = 'HTSTFDelayLineReset';
	
	
	case 'HTSTFDelayLineReset'
	% reset delay line for inband power estimator
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 1 0 0 0 0 0 0 0 0 0 1 1 1 1 ];
	cmd = 110; parameter1 = [0,0,0 ];
	op{1,1} = 'true'; op{1,2} = 'true'; op{1,3} = 'true'; pathComb{1} = 0; opComb{1} = 1; tgtState{1} = 'Wait4GainUpdate';

	case 'Wait4GainUpdate'
	% Wait for gain update
	% By franklin, disable saturation det
	nb_trans = 3; cmdEn = 0; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 600; dspEn = [0 1 0 0 0 0 0 0 0 0 0 1 1 1 1 ];
	op{1,1} = 'timeOut'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Wait4HTSIG';
	op{2,1} = 'rxEnd4Timing'; op{2,2} = 'true'; op{2,3} = 'true'; pathComb{2} = 0; opComb{2} = 1; tgtState{2} = 'ShortLRxEnd';
	op{3,1} = 'htstfGainUpdt'; op{3,2} = 'true'; op{3,3} = 'true'; pathComb{3} = 0; opComb{3} = 1; tgtState{3} = 'HTSet4Demod';

	case 'Wait4HTSIG'
	nb_trans = 2; cmdEn = 0; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 1 0 0 0 0 0 0 0 0 0 1 1 1 1 ];
	op{1,1} = 'validHTSIG'; op{1,2} = 'true'; op{1,3} = 'true'; pathComb{1} = 0; opComb{1} = 1; tgtState{1} = 'PreWait4RxEnd';
	op{2,1} = 'true'; op{2,2} = 'true'; op{2,3} = 'true'; pathComb{2} = 0; opComb{2} = 1; tgtState{2} = 'Wait4LRxEnd';

	case 'HTSet4Demod'
	% Set optimal analog and digital gains 4 demodulation inside HT-STF with ACI margin, op{1,1} noGainUpt ->false
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 5; dspEn = [0 1 0 0 0 0 0 0 0 0 0 1 1 1 1 ];
	cmd = 14; parameter1 = [-18,-22,4 ];
	op{1,1} = 'timeOut'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'HTAGCUnlock';

	case 'HTAGCUnlock'
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 ];
	cmd = 51; parameter1 = [0,0,1 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'HTDemodFEEn';

	case 'HTDemodFEEn'
	% Configure in-band power estimator
	% enable OFDM FE - wait 0.6us
	nb_trans = 1; cmdEn = 0; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 6; dspEn = [0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 ];
	op{1,1} = 'timeOut'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'HTOFDMon';

	case 'HTOFDMon'
	% enable OFDM modem
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 25; dspEn = [0 1 0 0 0 0 0 0 0 0 0 1 1 1 1 ];
	cmd = 51; parameter1 = [0,0,0];
	op{1,1} = 'timeOut'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SHTSTFStoreINBDPower';

	case 'SHTSTFStoreINBDPower'
	% OFDM has been verified after AGC
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 1 0 1 0 0 0 0 0 0 0 1 1 1 1 ];
	cmd = 65; parameter1 = [0,0,3 ];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'PreWait4RxEnd';

  case 'PreWait4RxEnd'
  % add by zhoujian for HETB Wait4RxEnd
  nb_trans = 2; cmdEn = 0; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 1 0 0 0 0 0 0 0 0 0 1 1 1 1 ];
  op{1,1} = 'RxTdmaEn'; op{1,2} = 'rxHETBEn'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Wait4HETBRxEnd';
  op{2,1} = 'true'; op{2,2} = 'false'; op{2,3} = 'false'; pathComb{2} = 0; opComb{2} = 0; tgtState{2} = 'Wait4RxEnd';

  case 'Wait4HETBRxEnd'
  % clean CCA flag
  nb_trans = 2; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 1 0 0 0 0 0 0 0 0 0 1 1 1 1 ];
  cmd = 41; parameter1 = [0,0,0 ];
  op{1,1} = 'rxEnd4Timing'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Check4RIFS';
  op{2,1} = 'false'; op{2,2} = 'rampDn'; op{2,3} = 'demodRun'; pathComb{2} = 0; opComb{2} = 4; tgtState{2} = 'SAbnormalOfdmStoreINBDPower';

	case 'Wait4RxEnd'
	% clean CCA flag
	nb_trans = 2; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 1 0 0 1 1 1 0 0 0 0 1 1 1 1 ];
	cmd = 41; parameter1 = [0,0,0];
	op{1,1} = 'rxEnd4Timing'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Check4RIFS';
	op{2,1} = 'false'; op{2,2} = 'rampDn'; op{2,3} = 'demodRun'; pathComb{2} = 0; opComb{2} = 4; tgtState{2} = 'SAbnormalOfdmStoreINBDPower';

	case 'Check4RIFS'
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [1 1 0 0 0 0 0 0 0 0 0 1 1 1 1 ];
	cmd = 12; parameter1 = [0,66,65 ];
	op{1,1} = 'true'; op{1,2} = 'true'; op{1,3} = 'true'; pathComb{1} = 0; opComb{1} = 1; tgtState{1} = 'SInitGainWait';
	
	case 'SInitGainWait'
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 12; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	cmd = 1; parameter1 = [0,0,0 ];
	op{1,1} = 'timeOut'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SRxEndCheckLNASat';
	
	case 'SRxEndCheckLNASat'
	nb_trans = 2; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 3; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	cmd = 60; parameter1 = [0,0,0];
	op{1,1} = 'LNASatDet'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SLNASatACICheck';
	op{2,1} = 'timeOut'; op{2,2} = 'false'; op{2,3} = 'false'; pathComb{2} = 0; opComb{2} = 0; tgtState{2} = 'SRxEndResetADCPowWindow';
	
	
	case 'SRxEndResetADCPowWindow'
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	cmd = 62; parameter1 = [0,2,0];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SRxEndResetInbdPowWindow';

	case 'SRxEndResetInbdPowWindow'
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	cmd = 61; parameter1 = [0,115,163];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SRxEndSet4ACIDetON';
 
	case 'SRxEndSet4ACIDetON'
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 0; sleepEn = 0; timeOutVal = 0; dspEn = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
	cmd = 16; parameter1 = [0,0,9];
	op{1,1} = 'true'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SRxEndSet4DetStartDC';

	case 'SRxEndSet4DetStartDC'
	% enable dc offset and FE + wait dc convergence
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 4; dspEn = [0 0 0 0 0 0 0 1 0 0 0 0 0 1 1 ];
	cmd = 64; parameter1 = [0,0,1 ];
	op{1,1} = 'timeOut'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'SRxEndSet4DetStartPow';

	case 'SRxEndSet4DetStartPow'
	% enable adc power estim and inband power estim and wait for conv / define min4sat,min,max gains
	nb_trans = 1; cmdEn = 1; cmdExtEn = 0; timeOutEn = 1; sleepEn = 0; timeOutVal = 34; dspEn = [1 1 0 0 0 0 0 1 0 0 0 1 1 1 1 ];
	cmd = 20; parameter1 = [11,35,63 ];
	op{1,1} = 'timeOut'; op{1,2} = 'false'; op{1,3} = 'false'; pathComb{1} = 0; opComb{1} = 0; tgtState{1} = 'Sleep';


