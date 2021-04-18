function dvbs2x_settings
%

% Block name for model dialog parameters
settingsBlkName = 'Model Parameters';

% Get parameters from model settings block.
settingsBlk = [bdroot '/' settingsBlkName];
[subsystemType, ...
 EsNodB, ...
 LDPCNumIterations, ...
 seed] = ...
 getparamvals(settingsBlk, ...
 'modulationAndCodingMode', ...
 'EsNodB', ...
 'LDPCNumIterations', ...
 'seed');

%--------------------------------------------------------------------------
% Modulation and coding mode    

dvb = getParamsDVBS2xDemo(subsystemType, ...
    EsNodB, ...
    LDPCNumIterations);
dvb.seed = seed;
dvb.VSS_APSK = contains(subsystemType,'APSK');
dvb.VSS_PSK = contains(subsystemType,'QPSK') | contains(subsystemType,'8PSK');

if (dvb.VSS_APSK)
    set_param('dvbs2x/Modulator/APSK Modulator/DVBS-APSK Modulator Baseband', 'StdSuffix', 'S2X');
    set_param('dvbs2x/Modulator/APSK Modulator/DVBS-APSK Modulator Baseband', 'ModOrder', num2str(dvb.ModulationOrder));
    set_param('dvbs2x/Modulator/APSK Modulator/DVBS-APSK Modulator Baseband', 'CodeIDF', dvb.CodeRate);

    set_param('dvbs2x/Demodulator/APSK Demodulator/DVBS-APSK Demodulator Baseband', 'StdSuffix', 'S2X');
    set_param('dvbs2x/Demodulator/APSK Demodulator/DVBS-APSK Demodulator Baseband', 'ModOrder', num2str(dvb.ModulationOrder));
    set_param('dvbs2x/Demodulator/APSK Demodulator/DVBS-APSK Demodulator Baseband', 'CodeIDF', dvb.CodeRate);
end

% Assign parameter structure to base workspace.
assignin('base', 'dvb', dvb);

%--------------------------------------------------------------------------
function varargout = getparamvals(blk, varargin)
% Get parameter values from block.  This process uses the 'Evaluate' check
% box (in the mask) to determine whether the parameter string should be
% evaluated in the base workspace.
h = get_param(blk, 'Handle');
maskVars = get(h, 'MaskVariables');
for n = 1:length(varargin)
    paramName = varargin{n};
    paramValStr = get(h, paramName);
    evalParam = maskVars(strfind(maskVars, paramName) ...
        + length(paramName) + 1) == '@';
    if evalParam
        varargout{n} = evalin('base', paramValStr);
    else
        varargout{n} = paramValStr;
    end
end

