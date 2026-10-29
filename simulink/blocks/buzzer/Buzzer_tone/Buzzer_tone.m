classdef Buzzer_tone < matlab.System ...
        & coder.ExternalDependency & matlabshared.devicedriverbuilder.Utilities

    %
    %#codegen
    %#ok<*EMCA>

    properties

    end

    properties(Access = protected)
        Logo = 'IO Device Builder';
    end

    properties (Nontunable)
        Pin(1,1) {mustBeA(Pin,'int8')} = int8(3);

    end

    properties (Access = private)
        % Pre-computed constants.


    end

    properties(Nontunable, Access = protected)
    end

    methods
        % Constructor
        function obj = Buzzer_tone(varargin)
            % Support name-value pair arguments when constructing the object.
            setProperties(obj,nargin,varargin{:});


        end
    end

    methods (Access=protected)
        function setupImpl(obj)

            if coder.target('RtwForRapid')
                % Rapid Accelerator. In this mode, coder.target('Rtw')
                % returns true as well, so it is important to check for
                % 'RtwForRapid' before checking for 'Rtw'

                %pass
            elseif ~coder.target('MATLAB')
                coder.cinclude('Buzzer_tone.h');
                coder.ceval('setupFunctionBuzzer_tone', (obj.Pin),1);
            end
        end

        function [varargout]=stepImpl(obj ,freq)
            if isempty(coder.target)
            elseif coder.target('RtwForRapid')
                % Rapid Accelerator. In this mode, coder.target('Rtw')
                % returns true as well, so it is important to check for
                % 'RtwForRapid' before checking for 'Rtw'

                %pass
            else
                coder.ceval('stepFunctionBuzzer_tone', freq,1);
            end
        end

        function releaseImpl(obj)
            if isempty(coder.target)
            elseif coder.target('RtwForRapid')
                % Rapid Accelerator. In this mode, coder.target('Rtw')
                % returns true as well, so it is important to check for
                % 'RtwForRapid' before checking for 'Rtw'

                %pass
            else

            end
        end
    end

    methods (Access=protected)
        %% Define input properties
        function num = getNumInputsImpl(~)
            num = 1;
        end

        function num = getNumOutputsImpl(~)
            num = 0;
        end

        function varargout = getInputNamesImpl(obj)
            varargout{1} = 'freq';

        end

        function varargout = isInputFixedSizeImpl(~,~)
            varargout{1} = true;
        end

        function varargout   = isOutputFixedSizeImpl(obj)
            for i = 1 : obj.getNumOutputsImpl
                varargout{i} = true;
            end
        end

        function varargout  = isOutputComplexImpl(obj)
            for i = 1 : obj.getNumOutputsImpl
                varargout{i} = false;
            end
        end

        function validateInputsImpl(obj,varargin)
            if isempty(coder.target)
                % Run input validation only in Simulation
                if nargin ~=0

                    validateattributes(varargin{1},{'double'},{'2d','size',[1,1]},'','freq');

                end
            end
        end

        % Block mask display
        function maskDisplayCmds = getMaskDisplayImpl(obj)
            outport_label = [];
            num = getNumOutputsImpl(obj);
            if num > 0
                outputs = cell(1,num);
                [outputs{1:num}] = getOutputNamesImpl(obj);
                for i = 1:num
                    outport_label = [outport_label 'port_label(''output'',' num2str(i) ',''' outputs{i} ''');' ]; %#ok<AGROW>
                end
            end
            inport_label = [];
            num = getNumInputsImpl(obj);
            if num > 0
                inputs = cell(1,num);
                [inputs{1:num}] = getInputNamesImpl(obj);
                for i = 1:num
                    inport_label = [inport_label 'port_label(''input'',' num2str(i) ',''' inputs{i} ''');' ]; %#ok<AGROW>
                end
            end
            icon = 'Buzzer_tone';
            maskDisplayCmds = [ ...
                ['color(''white'');',...
                'plot([100,100,100,100]*1,[100,100,100,100]*1);',...
                'plot([100,100,100,100]*0,[100,100,100,100]*0);',...
                'color(''blue'');', ...
                ['text(38, 92, ','''',obj.Logo,'''',',''horizontalAlignment'', ''right'');',newline],...
                'color(''black'');'], ...
                ['text(52,50,' [''' ' icon ''',''horizontalAlignment'',''center'');' newline]]   ...
                inport_label ...
                outport_label
                ];
        end

    end

    methods (Static, Access=protected)
        function simMode = getSimulateUsingImpl(~)
            simMode = 'Interpreted execution';
        end

        function isVisible = showSimulateUsingImpl
            isVisible = false;
        end
    end

    methods (Static)
        function name = getDescriptiveName(~)
            name = 'Buzzer_tone';
        end

        function tf = isSupportedContext(~)
            tf = true;
        end

        function updateBuildInfo(buildInfo, context)
            if context.isCodeGenTarget('rtw')
                isRaccelBuild = strcmp(context.getConfigProp('SystemTargetFile'), 'raccel.tlc');
                if ~isRaccelBuild

                    % Added this env variable to fetch the comm libraries required only for Arduino target.
                    % The env variable is cleared at the end of
                    % "GenerateWrapperMakefile.m" file.

                    filename = mfilename('fullpath');
                    [filepath,~,~] = fileparts(filename);

                                        SystemObjFiles = {'Buzzer_tone.cpp'};




                    buildInfo.addSourceFiles(SystemObjFiles,filepath);
                    buildInfo.addIncludePaths(filepath);
                end
            end
        end
    end
end