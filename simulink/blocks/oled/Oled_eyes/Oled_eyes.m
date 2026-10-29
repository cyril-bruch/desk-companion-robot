classdef Oled_eyes < matlab.System ...
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
        BlockParameter(1,1) {mustBeA(BlockParameter,'int8')} = int8(0);

    end

    properties (Access = private)
        % Pre-computed constants.


    end

    properties(Nontunable, Access = protected)
    end

    methods
        % Constructor
        function obj = Oled_eyes(varargin)
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
                coder.cinclude('Oled_eyes.h');
                coder.ceval('setupFunctionOled_eyes', (obj.BlockParameter),1);
            end
        end

        function [varargout]=stepImpl(obj ,face)
            if isempty(coder.target)
            elseif coder.target('RtwForRapid')
                % Rapid Accelerator. In this mode, coder.target('Rtw')
                % returns true as well, so it is important to check for
                % 'RtwForRapid' before checking for 'Rtw'

                %pass
            else
                coder.ceval('stepFunctionOled_eyes', face,1);
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
            varargout{1} = 'face';

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

                    validateattributes(varargin{1},{'double'},{'2d','size',[1,1]},'','face');

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
            icon = 'Oled_eyes';
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
            name = 'Oled_eyes';
        end

        function tf = isSupportedContext(~)
            tf = true;
        end

        function updateBuildInfo(buildInfo, context)
            coder.extrinsic('codertarget.targethardware.getTargetHardware');
            if context.isCodeGenTarget('rtw')
                isRaccelBuild = strcmp(context.getConfigProp('SystemTargetFile'), 'raccel.tlc');
                if ~isRaccelBuild
                    hCS = coder.const(getActiveConfigSet(bdroot));
                    targetInfo = coder.const(codertarget.targethardware.getTargetHardware(hCS));

                    % Added this env variable to fetch the comm libraries required only for Arduino target.
                    % The env variable is cleared at the end of
                    % "GenerateWrapperMakefile.m" file.
                    if contains(targetInfo.TargetName,'arduinotarget')
                        setenv('Arduino_ML_Codegen_I2C', 'Y');
                    end

                    filename = mfilename('fullpath');
                    [filepath,~,~] = fileparts(filename);

                    DriverFiles = {'U8g2lib.cpp','U8x8lib.cpp','mui.c','mui_u8g2.c','u8g2_arc.c','u8g2_bitmap.c','u8g2_box.c','u8g2_buffer.c','u8g2_button.c','u8g2_circle.c','u8g2_cleardisplay.c','u8g2_d_memory.c','u8g2_d_setup.c','u8g2_font.c','u8g2_fonts.c','u8g2_hvline.c','u8g2_input_value.c','u8g2_intersection.c','u8g2_kerning.c','u8g2_line.c','u8g2_ll_hvline.c','u8g2_message.c','u8g2_polygon.c','u8g2_selection_list.c','u8g2_setup.c','u8log.c','u8log_u8g2.c','u8log_u8x8.c','u8x8_8x8.c','u8x8_byte.c','u8x8_cad.c','u8x8_capture.c','u8x8_d_a2printer.c','u8x8_d_ch1120.c','u8x8_d_gp1247ai.c','u8x8_d_gp1287ai.c','u8x8_d_gp1294ai.c','u8x8_d_gu800.c','u8x8_d_hd44102.c','u8x8_d_il3820_296x128.c','u8x8_d_ist3020.c','u8x8_d_ist3088.c','u8x8_d_ist7920.c','u8x8_d_ks0108.c','u8x8_d_lc7981.c','u8x8_d_ld7032_60x32.c','u8x8_d_ls013b7dh03.c','u8x8_d_max7219.c','u8x8_d_pcd8544_84x48.c','u8x8_d_pcf8812.c','u8x8_d_pcf8814_hx1230.c','u8x8_d_s1d15300.c','u8x8_d_s1d15721.c','u8x8_d_s1d15e06.c','u8x8_d_sbn1661.c','u8x8_d_sed1330.c','u8x8_d_sh1106_64x32.c','u8x8_d_sh1106_72x40.c','u8x8_d_sh1107.c','u8x8_d_sh1108.c','u8x8_d_sh1122.c','u8x8_d_ssd1305.c','u8x8_d_ssd1306_128x32.c','u8x8_d_ssd1306_128x64_noname.c','u8x8_d_ssd1306_2040x16.c','u8x8_d_ssd1306_48x64.c','u8x8_d_ssd1306_64x32.c','u8x8_d_ssd1306_64x48.c','u8x8_d_ssd1306_72x40.c','u8x8_d_ssd1306_96x16.c','u8x8_d_ssd1306_96x40.c','u8x8_d_ssd1309.c','u8x8_d_ssd1312.c','u8x8_d_ssd1315_128x64_noname.c','u8x8_d_ssd1316.c','u8x8_d_ssd1317.c','u8x8_d_ssd1318.c','u8x8_d_ssd1320.c','u8x8_d_ssd1322.c','u8x8_d_ssd1325.c','u8x8_d_ssd1326.c','u8x8_d_ssd1327.c','u8x8_d_ssd1329.c','u8x8_d_ssd1362.c','u8x8_d_ssd1362z.c','u8x8_d_ssd1363.c','u8x8_d_ssd1606_172x72.c','u8x8_d_ssd1607_200x200.c','u8x8_d_st7301.c','u8x8_d_st7302.c','u8x8_d_st7305.c','u8x8_d_st7511.c','u8x8_d_st75160.c','u8x8_d_st75161.c','u8x8_d_st75256.c','u8x8_d_st7528.c','u8x8_d_st75320.c','u8x8_d_st7539.c','u8x8_d_st7565.c','u8x8_d_st7567.c','u8x8_d_st7571.c','u8x8_d_st7586s_erc240160.c','u8x8_d_st7586s_jlx320160.c','u8x8_d_st7586s_jlx384160.c','u8x8_d_st7586s_md240128.c','u8x8_d_st7586s_pe24064.c','u8x8_d_st7586s_s028hn118a.c','u8x8_d_st7586s_ymc240160.c','u8x8_d_st7588.c','u8x8_d_st7920.c','u8x8_d_t6963.c','u8x8_d_uc1601.c','u8x8_d_uc1604.c','u8x8_d_uc1608.c','u8x8_d_uc1609.c','u8x8_d_uc1610.c','u8x8_d_uc1611.c','u8x8_d_uc1617.c','u8x8_d_uc1628.c','u8x8_d_uc1638.c','u8x8_d_uc1698.c','u8x8_d_uc1701_dogs102.c','u8x8_d_uc1701_mini12864.c','u8x8_debounce.c','u8x8_display.c','u8x8_fonts.c','u8x8_gpio.c','u8x8_input_value.c','u8x8_message.c','u8x8_selection_list.c','u8x8_setup.c','u8x8_string.c','u8x8_u16toa.c','u8x8_u8toa.c',};
                    DriverFilesFolder = 'Dependencies';
                    SystemObjFiles = {'Oled_eyes.cpp'};




                    buildInfo.addSourceFiles(SystemObjFiles,filepath);
                    buildInfo.addSourceFiles(DriverFiles,fullfile(filepath,DriverFilesFolder));
                    buildInfo.addIncludePaths(filepath);
                    buildInfo.addIncludePaths(fullfile(filepath,DriverFilesFolder));
                end
            end
        end
    end
end