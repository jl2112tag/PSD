classdef PSDanalyser_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        PSDanalyserUIFigure             matlab.ui.Figure
        ColorbarCheckBox                matlab.ui.control.CheckBox
        ColormapDropDown                matlab.ui.control.DropDown
        ColormapDropDownLabel           matlab.ui.control.Label
        SystemStatusLabel               matlab.ui.control.Label
        StatusLabel                     matlab.ui.control.Label
        ImportDataButton                matlab.ui.control.Button
        ProjectEditField                matlab.ui.control.EditField
        ProjectEditFieldLabel           matlab.ui.control.Label
        Load1stTiffButton               matlab.ui.control.Button
        TabGroup                        matlab.ui.container.TabGroup
        ProcessFootageTab               matlab.ui.container.Tab
        ImageSizepixelEditField         matlab.ui.control.EditField
        ImageSizepixelEditFieldLabel    matlab.ui.control.Label
        LineExtractionPanel             matlab.ui.container.Panel
        MultiDropDown                   matlab.ui.control.DropDown
        MultiDropDownLabel              matlab.ui.control.Label
        Yminus10Button                  matlab.ui.control.Button
        Yminus1Button                   matlab.ui.control.Button
        Yplus1Button                    matlab.ui.control.Button
        Yplus10Button                   matlab.ui.control.Button
        EnableButton                    matlab.ui.control.StateButton
        ExtractButton                   matlab.ui.control.Button
        LinePositionpixelEditField      matlab.ui.control.NumericEditField
        LinePositionpixelEditFieldLabel  matlab.ui.control.Label
        DisplayPanel                    matlab.ui.container.Panel
        FrameSlider                     matlab.ui.control.Slider
        FrameSliderLabel                matlab.ui.control.Label
        StopButton                      matlab.ui.control.Button
        Backward10Button                matlab.ui.control.Button
        Forward10Button                 matlab.ui.control.Button
        Forward1Button                  matlab.ui.control.Button
        Backward1Button                 matlab.ui.control.Button
        TimesEditField                  matlab.ui.control.NumericEditField
        TimesEditFieldLabel             matlab.ui.control.Label
        FrameEditField                  matlab.ui.control.NumericEditField
        FrameEditFieldLabel             matlab.ui.control.Label
        PlayButton                      matlab.ui.control.Button
        PlaySelectedButton              matlab.ui.control.Button
        RemoveSelectedButton            matlab.ui.control.Button
        FootageInformationPanel         matlab.ui.container.Panel
        ApplyFPSButton                  matlab.ui.control.Button
        DisplayHSTFrameButton           matlab.ui.control.Button
        HydrationStartFrameEditField    matlab.ui.control.NumericEditField
        HydrationStartFrameEditFieldLabel  matlab.ui.control.Label
        MeasurementDateEditField        matlab.ui.control.EditField
        MeasurementDateEditFieldLabel   matlab.ui.control.Label
        TotalFootageTimesEditField      matlab.ui.control.NumericEditField
        TotalFootageTimesEditFieldLabel  matlab.ui.control.Label
        TotalFrameNumberEditField       matlab.ui.control.NumericEditField
        TotalFrameNumberEditFieldLabel  matlab.ui.control.Label
        FramePerSecondEditField         matlab.ui.control.NumericEditField
        FramePerSecondEditFieldLabel    matlab.ui.control.Label
        UITable                         matlab.ui.control.Table
        UIAxes                          matlab.ui.control.UIAxes
        ExtractedLinesTab               matlab.ui.container.Tab
        MemoryResetButton               matlab.ui.control.Button
        ImageAnalysisPanel              matlab.ui.container.Panel
        ParticleAnalysisButton          matlab.ui.control.Button
        DichotomisationPanel            matlab.ui.container.Panel
        ReturnButton                    matlab.ui.control.Button
        ThresholdSpinner                matlab.ui.control.Spinner
        ThresholdSpinnerLabel           matlab.ui.control.Label
        SaveButton_2                    matlab.ui.control.Button
        DichotomiseButton               matlab.ui.control.Button
        GaussianBlurButton              matlab.ui.control.Button
        SigmaDropDown                   matlab.ui.control.DropDown
        SigmaDropDownLabel              matlab.ui.control.Label
        SaveButton                      matlab.ui.control.Button
        LoadButton                      matlab.ui.control.Button
        MovetoWorkspaceButton           matlab.ui.control.Button
        RemoveSelectedButton_2          matlab.ui.control.Button
        ScaleUpButton                   matlab.ui.control.Button
        ScaleDownButton                 matlab.ui.control.Button
        EL_BB_Button                    matlab.ui.control.Button
        EL_FF_Button                    matlab.ui.control.Button
        DisplayRangesecLabel            matlab.ui.control.Label
        toEditField                     matlab.ui.control.NumericEditField
        toEditFieldLabel                matlab.ui.control.Label
        fromEditField                   matlab.ui.control.NumericEditField
        fromEditFieldLabel              matlab.ui.control.Label
        EL_B_Button                     matlab.ui.control.Button
        EL_F_Button                     matlab.ui.control.Button
        UITable_EL                      matlab.ui.control.Table
        UIAxes_EL                       matlab.ui.control.UIAxes
        ParticleDistributionTab         matlab.ui.container.Tab
        GridCheckBox                    matlab.ui.control.CheckBox
        DataDropDown                    matlab.ui.control.DropDown
        DataDropDownLabel               matlab.ui.control.Label
        AnimationButton                 matlab.ui.control.Button
        TotalBinCountEditField          matlab.ui.control.NumericEditField
        TotalBinCountEditFieldLabel     matlab.ui.control.Label
        LegendCheckBox                  matlab.ui.control.CheckBox
        MovetoWorkspacePDButton         matlab.ui.control.Button
        PlotButton                      matlab.ui.control.Button
        SavePDButton                    matlab.ui.control.Button
        LoadPDButton                    matlab.ui.control.Button
        RemoveButton                    matlab.ui.control.Button
        ObservationsListBox             matlab.ui.control.ListBox
        ObservationsListBoxLabel        matlab.ui.control.Label
        UIAxes_PDH                      matlab.ui.control.UIAxes
        UIAxes_PD                       matlab.ui.control.UIAxes
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Particle Size Distribution Analyser for Disintegration Process Modelling
% Created by Jongmin Lee, University of Cambridge, UK. 2023
% Contact Information: jl2112@cam.ac.uk
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    properties (Access = private)
        filefullpath; % Description
        Div % directory divider (windows/iOS)
        tableSelection % selected table cell indices
        stopProcess % process stop flag
        Handler % axis component handler
        imgHeight % image height (pixel)
        imgWidth % image width (pixel)
        ELdata = [] % extracted line data
        tableSelection_EL % selected EL table cell indices
        dispIdx % index of currently displayed image in PD tab
        dispScale % Width of displayed image in PD tab
        ELTemp % extracted line image temp file for filtering
        isFiltering % filtering flag
        isDistribution % distribution flag
        PDdata % particle distrubution analysis data
    end
    
    methods (Access = private)
        
        function UpdateFootageInfo(app,FPS)
            
            try
                T2 = app.UITable.Data;
            catch ME
                return;
            end
            
            totalFNum = sum(T2.frameNum);
            app.TotalFrameNumberEditField.Value = totalFNum;
            app.FramePerSecondEditField.Value = FPS;
            app.TotalFootageTimesEditField.Value = T2.second(end) + T2.frameNum(end)/FPS;
            app.FrameEditField.Limits = [1, totalFNum];
            app.HydrationStartFrameEditField.Limits = [1, totalFNum];
            app.FrameSlider.Limits = [1, totalFNum];
            app.TimesEditField.Limits = [0, floor(totalFNum*100/FPS)/100];
            app.LinePositionpixelEditField.Limits = [1,app.imgHeight];
            app.ImageSizepixelEditField.Value = strcat(num2str(app.imgWidth),'x',num2str(app.imgHeight));
        end
        
        function DispImage(app,frm);
            ax = app.UIAxes;
            T2 = app.UITable.Data;
            idx = sum(T2.frameSrt <= frm);
            FPS = app.FramePerSecondEditField.Value;
            
            fileinfo = app.filefullpath;
            [filepath,~,~] = fileparts(fileinfo);
            filepath = strcat(filepath,app.Div);
            filename = string(T2.fName(idx));
            imgFile = strcat(filepath,filename);
            
            
            cmap = app.ColormapDropDown.Value;
            colormap(ax,cmap);
            axis(ax,"image");
            
            if app.ColorbarCheckBox.Value
                colorbar(ax,"westoutside")
            else
                colorbar(ax,"off")
            end
                        
            app.FrameEditField.Value = frm;
            app.FrameSlider.Value = frm;
            app.TimesEditField.Value = floor(frm/FPS*100)/100;
            im = imread(imgFile,frm-T2.frameSrt(idx)+1);
            imagesc(ax,im); 
            
            if app.EnableButton.Value
                lineLoc = app.LinePositionpixelEditField.Value;
                app.Handler.yline = yline(ax,lineLoc,'r--','LineWidth',1);
            end
            
            drawnow
        end
        
        
        function FrameShift(app,val)
            value = app.FrameEditField.Value;
            value = value + val;
            app.FrameEditField.Value = value;
            DispImage(app,value);
        end
        
        function LineShift(app,val)
            if app.EnableButton.Value
                value = app.LinePositionpixelEditField.Value;
                value = value + val;
                app.LinePositionpixelEditField.Value = value;
                app.Handler.yline.Value = value;    
            end
        end
        
        function ResetSetting(app)
            app.EnableButton.Value = false;
            app.LinePositionpixelEditField.Value = 1;
        end
        
        function ExtractLines(app)
            app.stopProcess = false;
            srtFrame = app.HydrationStartFrameEditField.Value;
            endFrame = app.TotalFrameNumberEditField.Value;
            totFrame = endFrame - srtFrame + 1;
            lineLoc = app.LinePositionpixelEditField.Value;
            lineNum = str2num(app.MultiDropDown.Value);
            T2 = app.UITable.Data;
            FPS = app.FramePerSecondEditField.Value;
            imgWidth = app.imgWidth;
            srtWidth = floor(imgWidth*0.20);
            endWidth = imgWidth - srtWidth;
            imgWidth = endWidth - srtWidth + 1;
            lineMat = zeros(imgWidth,totFrame*lineNum);
            dataSetNum = size(app.ELdata,2);            
            crtLine = 1;
            
            % extract lines
            for frm = srtFrame:endFrame
                idx = sum(T2.frameSrt <= frm);
                fileinfo = app.filefullpath;
                [filepath,~,~] = fileparts(fileinfo);
                filepath = strcat(filepath,app.Div);
                filename = string(T2.fName(idx));
                imgFile = strcat(filepath,filename);
                
                im = imread(imgFile,frm-T2.frameSrt(idx)+1);
                lineVec = im(lineLoc-lineNum+1:lineLoc,srtWidth:endWidth);
                lineMat(1:imgWidth,crtLine:crtLine+lineNum-1) = lineVec';
                crtLine = crtLine + lineNum;
                
                % display progress
                progressP = (frm-srtFrame+1)/totFrame*100;
                progressP = num2str(progressP,'%.0f');
                progressP = strcat(progressP,"%"," extracted");
                app.SystemStatusLabel.Text = progressP;
                drawnow
                
                if app.stopProcess
                    lineMat = [];
                    return
                end
                
            end
            
            app.SystemStatusLabel.Text = "Extraction finished";
            app.ELdata(dataSetNum+1).lineMat = lineMat;
            app.ELdata(dataSetNum+1).projectName = app.ProjectEditField.Value;
            app.ELdata(dataSetNum+1).lineExtracted = lineLoc;
            app.ELdata(dataSetNum+1).lineNumber = lineNum;
            app.ELdata(dataSetNum+1).runTime = floor(totFrame/FPS*100)/100;
            app.ELdata(dataSetNum+1).imageSize = [imgWidth,totFrame*lineNum];
            app.ELdata(dataSetNum+1).binary = false;
            
            RefreshELTable(app);
        end
        
        function RefreshELTable(app)
            dataSetNum = size(app.ELdata,2);
            
            if dataSetNum==0
                return
            end
            
            projectNames = cell(dataSetNum,1);
            lineExtracteds = zeros(dataSetNum,1);
            lineNums = zeros(dataSetNum,1);
            runTimes = zeros(dataSetNum,1);
            binary = false(dataSetNum,1);
            
            for idx = 1:dataSetNum
                projectNames(idx) = {app.ELdata(idx).projectName};
                lineExtracteds(idx) = app.ELdata(idx).lineExtracted;
                lineNums(idx) = app.ELdata(idx).lineNumber;
                runTimes(idx) = app.ELdata(idx).runTime;
                binary(idx) = app.ELdata(idx).binary;
            end
            
            T = table(projectNames,lineExtracteds,lineNums,runTimes,binary);
            app.UITable_EL.Data = T;            
        end
        
        function DispShift(app,val)
            
            try
                idx = app.dispIdx(1);
                lLoc = app.dispIdx(2);
                
                if app.isFiltering
                    im = app.ELTemp.lineMat;
                    imgWidth = app.ELTemp.imageSize(2);
                else

                    im = app.ELdata(idx).lineMat;
                    imgWidth = app.ELdata(idx).imageSize(2); % whole image width
                end
            catch ME
                return
            end
            
            crtImgWidth = app.dispScale; % current image width
            SPL = app.ELdata(idx).runTime/imgWidth; % second per line
%             SPL = floor(SPL*100)/100;
            itv = crtImgWidth;
            lLoc = lLoc + val;
            
            if lLoc < 1
                lLoc = 1;
            elseif (lLoc+itv)>imgWidth
                lLoc = imgWidth - itv + 1;
            end
            
            app.Handler.imagesc.CData = im(:,lLoc:lLoc+itv-1);
            app.dispIdx = [idx, lLoc];
            
            app.fromEditField.Value = floor((lLoc-1) * SPL*100)/100;
            app.toEditField.Value = floor((lLoc + itv -1)*SPL*100)/100;
        end
        
        function RefreshPDList(app)
            % observations list update
            try
                PDdataNum = size(app.PDdata,2);
                ListBoxItems={};
            catch ME
                return
            end
            
            for idx = 1:PDdataNum
                AddItem = app.PDdata(idx).listName;
                ListBoxItems{idx} = AddItem;
            end
            
            app.ObservationsListBox.ItemsData = (1:PDdataNum);
            app.ObservationsListBox.Items = ListBoxItems;
        end
        
        function DPDisplay(app,mode)
            
            try
                if isequal(mode,"plot")
                    idxList = app.ObservationsListBox.Value;
                else
                    idxList = app.ObservationsListBox.ItemsData;
                end
                
            catch ME
                return
            end
            
            ax1 = app.UIAxes_PD;
            ax2 = app.UIAxes_PDH;
            option = app.DataDropDown.Value;
            legendList = {};
            cnt = 1;
            
            for idx = idxList
                PDdata = app.PDdata(idx);
                stats = PDdata.stats;
                SPL = PDdata.SPL;
                timeLine = stats.Centroid(:,1)*SPL;
                timeLine = floor(timeLine*100)/100;
                hPosition = stats.Centroid(:,2);
                pixelArea = pi.*stats.MajorAxisLength.*stats.MinorAxisLength./4;
                pixelAreaCum = cumsum(pixelArea);
                width = PDdata.width;
                
                % if isequal(option,"Spatial")
                %     ylabel(ax1,'Horizontal Location (pixel)');
                %     scatter(ax1,timeLine,hPosition,pixelArea);
                %     ax1.YLim = [1,width];
                % else                    
                %     ylabel(ax1,'Particle Size (pixel)');
                %     scatter(ax1,timeLine,pixelArea);
                %     ax1.YLim = [1,500];
                % end

                switch option
                    case "Spatial"
                        ylabel(ax1,'Horizontal Location (pixel count)');
                        scatter(ax1,timeLine,hPosition,pixelArea);
                        ax1.YLim = [1,width];
                        ax1.XLim = [0 inf];
                    case "Temporal"
                        ylabel(ax1,'Particle Size (pixel count)');
                        scatter(ax1,timeLine,pixelArea);
                        ax1.YLim = [1,500];
                        ax1.XLim = [0 inf];
                    case "Cumulative"
                        ylabel(ax1,'Cumulative Particle Size (pixel count)');
                        plot(ax1,timeLine,pixelAreaCum);
                        ax1.YLim = [1 inf];
                        ax1.XLim = [0 inf];
                end
                
                binEdgeVec = (0:10:300);
                histogram(ax2,pixelArea,"DisplayStyle","stairs","BinEdges",binEdgeVec);
                legendList(cnt) = {PDdata.listName};
                cnt = cnt + 1;
                
                if isequal(mode,"plot")
                    hold(ax1,"on")
                    hold(ax2,"on")
                else
                    legend(ax1,PDdata.listName,"Interpreter","none");
                    legend(ax2,PDdata.listName,"Interpreter","none");
                    pause(0.5)
                end

            end
            
            if app.LegendCheckBox.Value
                legend(ax1,legendList,"Interpreter","none")
                legend(ax2,legendList,"Interpreter","none")
            else
                legend(ax1,"off")
                legend(ax2,"off")
            end

            if app.GridCheckBox.Value
                grid(ax1,"on")
            else
                grid(ax1,"off")
            end
            
            hold(ax1,"off")
            hold(ax2,"off")
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: Load1stTiffButton
        function Load1stTiffButtonPushed(app, event)
            [filename, pathname] = uigetfile('*.tif');

            if isequal(filename,0)||isequal(pathname,0)
                return;          
            end
            
            fileinfo = strcat(pathname,filename);
            app.filefullpath = fileinfo;
            
            Div = pathname(end);
            app.Div = Div;
            folderDiv = findstr(pathname,Div);
                     
            ProjectName = strrep(extractAfter(pathname(1:end-1),folderDiv(end-2)),Div,'_');
            app.ProjectEditField.Value = ProjectName;
            title(app.UIAxes,ProjectName,"Interpreter","none")
            
            app.ImportDataButton.Enable = true;
        end

        % Button pushed function: ImportDataButton
        function ImportDataButtonPushed(app, event)
            fileinfo = app.filefullpath;
            [filepath,name,ext] = fileparts(fileinfo);
            filepath = strcat(filepath,app.Div);
            filename = strcat(name,ext);
            fInfo = dir(filepath);
            fInfo = rmfield(fInfo,"folder");
            fInfo = rmfield(fInfo,"datenum");
            fileNum = size(fInfo,1);
            idx = 1;
            itr = fileNum;
            
            
            % remove directories from folderInfo
            while itr
                if fInfo(idx).isdir
                   fInfo(idx) = [];
                else
                    idx = idx + 1;
                end
                itr = itr - 1;
            end
                
            fInfo = rmfield(fInfo,"isdir");
            fInfo = rmfield(fInfo,"bytes");
            fileNum = size(fInfo,1);
            fName = cell(fileNum,1);
            frameNum = zeros(fileNum,1);
            second = zeros(fileNum,1);
            
            for idx = 1:fileNum
                % Change date and time to second
                t = fInfo(idx).date;
                [Y, M, D, H, MM, S] = datevec(t);
                sec = H*3600+MM*60+S;
                fInfo(idx).second = sec;
                
                tifPathName = strcat(filepath,fInfo(idx).name);
                tifInfo = imfinfo(tifPathName);
                tifFrameNum = size(tifInfo,1);
                
                fName(idx) = {fInfo(idx).name};
                
                if isequal(fInfo(idx).name,filename)
                    srtSecond = fInfo(idx).second;
                    imgWidth = tifInfo(1).Width;
                    imgHeight = tifInfo(1).Height;
                    imgDate = fInfo(idx).date;
                end
                
                second(idx) = fInfo(idx).second;
                frameNum(idx) = tifFrameNum;
                
                % display progress
                progressP = (idx)/fileNum*100;
                progressP = num2str(progressP,'%.0f');
                progressP = strcat(progressP,"%"," imported");
                app.SystemStatusLabel.Text = progressP;
                drawnow

%                 ResetSetting(app);
            end
            
            % create the file list table
            second = second - srtSecond;
            NegItems = second < 0;
            T1= table(fName,second,frameNum);
            T1(NegItems,:) = [];
            T2 = sortrows(T1,[2]);
            frameSrt = cumsum(T2.frameNum);
            frameSrt = [1; frameSrt(1:end-1)+1];
            T2.frameSrt = frameSrt;
            app.UITable.Data = T2;
            
            % allocate image details
            try
                FPS = T2.frameNum(1)*3/T2.second(4);                
            catch ME
                FPS = T2.frameNum(1)/T2.second(2);                
            end
            
            FPS = floor(FPS*100)/100;
            app.imgHeight = imgHeight;
            app.imgWidth = imgWidth;
            
            UpdateFootageInfo(app,FPS);
            app.ImageSizepixelEditField.Value = strcat(num2str(imgWidth),'x',num2str(imgHeight));
            app.MeasurementDateEditField.Value = imgDate;
            app.SystemStatusLabel.Text = "Importing finished";
            DispImage(app,1);
            
%             assignin("base","T2",T2);
        end

        % Button pushed function: RemoveSelectedButton
        function RemoveSelectedButtonPushed(app, event)
            try
                indices = app.tableSelection;
                T2 = app.UITable.Data;
                
                if isempty(indices)
                    indices = size(T2); % remove the last row without selecting it
                end
                
            catch ME
                return;
            end
            
            T2(indices(1),:) = [];
            
            if size(T2,1)<=1
                return
            end
            
            % start frame number correction
            frameSrt = cumsum(T2.frameNum);
            frameSrt = [1; frameSrt(1:end-1)+1];
            T2.frameSrt = frameSrt;
            
            % time correction
            srtSecond = T2.second(1);
            if ~isequal(srtSecond,0)
                T2.second = T2.second - srtSecond;
            end
                        
            if indices(1) == 1
                % image size correction
                fileinfo = app.filefullpath;
                [filepath,~,~] = fileparts(fileinfo);
                filepath = strcat(filepath,app.Div);
                filename = string(T2.fName(1));
                imgFile = strcat(filepath,filename);
                
                imageSize = size(imread(imgFile));
                app.imgWidth = imageSize(1);
                app.imgHeight = imageSize(2);
                
                % Frame Per Second correction
                try
                    FPS = T2.frameNum(1)*3/T2.second(4);                
                catch ME
                    FPS = T2.frameNum(1)/T2.second(2);                
                end            
                FPS = floor(FPS*100)/100;
                app.FramePerSecondEditField.Value = FPS;
            end
            
            app.UITable.Data = T2;
            app.tableSelection = [];
            UpdateFootageInfo(app,app.FramePerSecondEditField.Value);
            
        end

        % Cell selection callback: UITable
        function UITableCellSelection(app, event)
            indices = event.Indices;
            app.tableSelection = indices;
            T2 = app.UITable.Data;
            frm = T2.frameSrt(indices(1));

            DispImage(app,frm);
            
        end

        % Button pushed function: ApplyFPSButton
        function ApplyFPSButtonPushed(app, event)
            FPS = app.FramePerSecondEditField.Value;
            UpdateFootageInfo(app,FPS);
        end

        % Button pushed function: PlayButton
        function PlayButtonPushed(app, event)
            app.stopProcess = false;
            srtFrame = app.FrameEditField.Value;
            
            itv = 3;
            
            for idx = srtFrame:itv:app.TotalFrameNumberEditField.Value
                DispImage(app,idx);
                drawnow
                
                if app.stopProcess
                    return;
                end
            end
            
        end

        % Button pushed function: PlaySelectedButton
        function PlaySelectedButtonPushed(app, event)
            app.stopProcess = false;
            try
                indices = app.tableSelection;
                T2 = app.UITable.Data;
            catch ME
                return;
            end
            
            srtFrm = T2.frameSrt(indices(1));
            endFrm = srtFrm + T2.frameNum(indices(1))-1;
            itv = 3;
            
            for idx = srtFrm:itv:endFrm
                DispImage(app,idx);
                drawnow
                
                if app.stopProcess
                    return;
                end
            end
            
        end

        % Button pushed function: StopButton
        function StopButtonPushed(app, event)
            app.stopProcess = true;
        end

        % Value changed function: FrameEditField
        function FrameEditFieldValueChanged(app, event)
            value = app.FrameEditField.Value;
            DispImage(app,value);
        end

        % Value changed function: EnableButton
        function EnableButtonValueChanged(app, event)
            value = app.EnableButton.Value;
            ax = app.UIAxes;
            imgHeight = app.imgHeight;
            initLoc = floor(imgHeight/2);
            
            if value
                app.LinePositionpixelEditField.Value = initLoc;
                app.Handler.yline = yline(ax,initLoc,'r--','LineWidth',1);
                app.Handler.yline.Visible = true;
            else
                app.LinePositionpixelEditField.Value = 1;
                app.Handler.yline.Visible = false;
            end
        end

        % Value changing function: FrameSlider
        function FrameSliderValueChanging(app, event)
            changingValue = floor(event.Value);
            DispImage(app,changingValue);
        end

        % Button pushed function: Forward1Button
        function Forward1ButtonPushed(app, event)
            FrameShift(app,1);
        end

        % Button pushed function: Forward10Button
        function Forward10ButtonPushed(app, event)
            FrameShift(app,10);
        end

        % Button pushed function: Backward1Button
        function Backward1ButtonPushed(app, event)
            FrameShift(app,-1);
        end

        % Button pushed function: Backward10Button
        function Backward10ButtonPushed(app, event)
            FrameShift(app,-10);
        end

        % Value changed function: FrameSlider
        function FrameSliderValueChanged(app, event)
            value = app.FrameSlider.Value;
            
        end

        % Button pushed function: Yplus1Button
        function Yplus1ButtonPushed(app, event)
            LineShift(app,1);
        end

        % Button pushed function: Yplus10Button
        function Yplus10ButtonPushed(app, event)
            LineShift(app,10);
        end

        % Button pushed function: Yminus1Button
        function Yminus1ButtonPushed(app, event)
            LineShift(app,-1);
        end

        % Button pushed function: Yminus10Button
        function Yminus10ButtonPushed(app, event)
            LineShift(app,-10);
        end

        % Value changed function: LinePositionpixelEditField
        function LinePositionpixelEditFieldValueChanged(app, event)
            value = app.LinePositionpixelEditField.Value;
            LineShift(app,0);            
        end

        % Button pushed function: ExtractButton
        function ExtractButtonPushed(app, event)
            if app.EnableButton.Value
                ExtractLines(app);
%                 app.TabGroup.SelectedTab = app.TabGroup.Children(2);
            end
        end

        % Button pushed function: LoadButton
        function LoadButtonPushed(app, event)
            RefreshELTable(app);
        end

        % Button pushed function: SaveButton
        function SaveButtonPushed(app, event)
            filter = {'*.mat';'*.*'};
            [filename, filepath] = uiputfile(filter);
            
            if isequal(filename,0)||isequal(filepath,0)
                return;          
            end
            
            fullfile = strcat(filepath,filename);
            app.SystemStatusLabel.Text = 'Project saving...';
            drawnow
            
            ELdata = app.ELdata;
                      
            save(fullfile,'ELdata');
            app.SystemStatusLabel.Text = 'Project saved.';
        end

        % Button pushed function: MovetoWorkspaceButton
        function MovetoWorkspaceButtonPushed(app, event)
            assignin("base","ELdata",app.ELdata);
            assignin("base","T",app.UITable_EL.Data);
        end

        % Button pushed function: RemoveSelectedButton_2
        function RemoveSelectedButton_2Pushed(app, event)
            try
                idx = app.tableSelection_EL(1);
                T = app.UITable_EL.Data;
                if isempty(idx)
                    return
                end
            catch ME
                return;
            end
            
            T(idx,:) = [];
            app.ELdata(idx) = [];
            
            app.UITable_EL.Data = T;
            app.tableSelection_EL = [];
        end

        % Callback function
        function DisplaySelectedButtonPushed(app, event)
            
            try
                idx = app.tableSelection_EL;
                idx = idx(1);
                im = app.ELdata(idx).lineMat;
                imgWidth = app.ELdata(idx).imageSize;
                imgWidth = imgWidth(2);
                app.dispIdx = [idx, 1];
                SPL = app.ELdata(idx).runTime/imgWidth;
                SPL = floor(SPL*100)/100;
                app.dispScale = 1000;
            catch ME
                return
            end
            
            T = app.UITable_EL.Data;
            titleStr = strcat(T.projectNames(idx),'_Line',num2str(T.lineExtracteds(idx)));
            ax = app.UIAxes_EL;
            cmap = app.ColormapDropDown.Value;
            colormap(ax,cmap);
            axis(ax,"image");
            
            if app.ColorbarCheckBox.Value
                colorbar(ax,"westoutside")
            else
                colorbar(ax,"off")
            end
            
            title(ax,titleStr,"Interpreter","none");
            
            if imgWidth > 1000
                imgWidth = 1000;
            end
            
            app.Handler.imagesc = imagesc(ax,im(:,1:imgWidth));
            app.fromEditField.Value = 0;
            app.toEditField.Value = imgWidth*SPL;
            
            
            
        end

        % Cell selection callback: UITable_EL
        function UITable_ELCellSelection(app, event)
            indices = event.Indices;
            app.tableSelection_EL = indices;

            idx = indices(1);
            im = app.ELdata(idx).lineMat;
            imgWidth = app.ELdata(idx).imageSize;
            imgWidth = imgWidth(2);
            app.dispIdx = [idx, 1];
            SPL = app.ELdata(idx).runTime/imgWidth;
            SPL = floor(SPL*100)/100;
            app.dispScale = 1000;
            app.isFiltering = 0;
            
            T = app.UITable_EL.Data;
            titleStr = strcat(T.projectNames(idx),'_Line',num2str(T.lineExtracteds(idx)));
            ax = app.UIAxes_EL;
            cmap = app.ColormapDropDown.Value;
            colormap(ax,cmap);
            axis(ax,"image");
            
            if app.ColorbarCheckBox.Value
                colorbar(ax,"westoutside")
            else
                colorbar(ax,"off")
            end
            
            title(ax,titleStr,"Interpreter","none");
            
            if imgWidth > 1000
                imgWidth = 1000;
            end
           
            app.Handler.imagesc = imagesc(ax,im(:,1:imgWidth));
            app.fromEditField.Value = 0;
            app.toEditField.Value = imgWidth*SPL; 
        end

        % Button pushed function: DisplayHSTFrameButton
        function DisplayHSTFrameButtonPushed(app, event)
            frm = app.HydrationStartFrameEditField.Value;
            DispImage(app,frm);
        end

        % Button pushed function: EL_F_Button
        function EL_F_ButtonPushed(app, event)
            DispShift(app,100);
        end

        % Button pushed function: EL_B_Button
        function EL_B_ButtonPushed(app, event)
            DispShift(app,-100);
        end

        % Button pushed function: EL_FF_Button
        function EL_FF_ButtonPushed(app, event)
            DispShift(app,500);
        end

        % Button pushed function: EL_BB_Button
        function EL_BB_ButtonPushed(app, event)
            DispShift(app,-500);
        end

        % Button pushed function: ScaleUpButton
        function ScaleUpButtonPushed(app, event)
            try
                idx = app.dispIdx(1);  
                crtImgWidth = app.dispScale;
                imgWidth = app.ELdata(idx).imageSize(2);
                crtImgWidth = crtImgWidth + 1000;
            catch ME
                return
            end
            
            if crtImgWidth >= imgWidth
                app.dispIdx= [idx,1];
                crtImgWidth = imgWidth;
            end
            
            app.dispScale = crtImgWidth;
            DispShift(app,0);
        end

        % Button pushed function: ScaleDownButton
        function ScaleDownButtonPushed(app, event)
            try
                idx = app.dispIdx(1);  
                crtImgWidth = app.dispScale;
                imgWidth = app.ELdata(idx).imageSize(2);
                crtImgWidth = crtImgWidth - 1000;
            catch ME
                return
            end

            
            if crtImgWidth < 1000
                
                if imgWidth > 1000
                    crtImgWidth = 1000;
                else
                    crtImgWidth = imgWidth;
                end
                
            end
            
            app.dispScale = crtImgWidth;
            DispShift(app,0);
        end

        % Button pushed function: GaussianBlurButton
        function GaussianBlurButtonPushed(app, event)
            
            try
                if app.isFiltering
                    im = app.ELTemp.lineMat;
                else
                    idx = app.dispIdx(1);
                    im = app.ELdata(idx).lineMat;
                    app.ELTemp = app.ELdata(idx);
                end
            catch ME
                return
            end
            
            app.SystemStatusLabel.Text = "Gaussian filtering in process";
            drawnow
            
            sigma = str2num(app.SigmaDropDown.Value);
            app.ELTemp.lineMat = imgaussfilt(im,sigma);
            app.SystemStatusLabel.Text = "Gaussian filtering finished";
            app.isFiltering = 1;
            DispShift(app,0);
        end

        % Button pushed function: DichotomiseButton
        function DichotomiseButtonPushed(app, event)
            
            try
                if app.isFiltering
                    im = app.ELTemp.lineMat;
                else
                    idx = app.dispIdx(1);
                    im = app.ELdata(idx).lineMat;
                    app.ELTemp = app.ELdata(idx);
                end
            catch ME
                return
            end
            
            app.SystemStatusLabel.Text = "Dochotomising in process";
            drawnow
            
            threshold = app.ThresholdSpinner.Value;
            im = (im>=threshold);
            app.ELTemp.lineMat = im;
            app.isFiltering = 1;
            app.SystemStatusLabel.Text = "Dichotomising finished";
            DispShift(app,0);
        end

        % Button pushed function: SaveButton_2
        function SaveButton_2Pushed(app, event)
            if app.isFiltering
                
                try
                    idx = app.dispIdx(1);
                    app.ELdata(idx).lineMat = app.ELTemp.lineMat;
                    app.ELdata(idx).binary = true;
                catch ME
                    return
                end
                app.isFiltering = 0;
                
            else
                return
            end
            
            RefreshELTable(app);
        end

        % Button pushed function: ReturnButton
        function ReturnButtonPushed(app, event)
            app.isFiltering = 0;
            DispShift(app,0);
        end

        % Button pushed function: ParticleAnalysisButton
        function ParticleAnalysisButtonPushed(app, event)
            
            try
                idx = app.dispIdx(1);
            catch ME
                return
            end
            
            if app.ELdata(idx).binary
                ELdata = app.ELdata(idx);
                im = ELdata.lineMat;
                im = ~im;
            else
                fig = app.PSDanalyserUIFigure;
                uialert(fig,'Selected item is not saved after filtering','Warning');
                return;
            end
            
            stats = regionprops('table',im,'Centroid','MajoraxisLength','MinoraxisLength');
            stats.Area = pi.*stats.MajorAxisLength.*stats.MinorAxisLength/4;
            
            listName = strcat(ELdata.projectName,'(',num2str(ELdata.lineExtracted),',',num2str(ELdata.lineNumber),')');
            SPL = ELdata.runTime/ELdata.imageSize(2); %second per line (pixel)

            PDdataNum = size(app.PDdata,2);
            app.PDdata(PDdataNum+1).listName = listName;
            app.PDdata(PDdataNum+1).stats = stats;
            app.PDdata(PDdataNum+1).SPL = SPL;
            app.PDdata(PDdataNum+1).width = ELdata.imageSize(1);
            
            RefreshPDList(app);
%             app.TabGroup.SelectedTab = app.TabGroup.Children(3);
            
        end

        % Button pushed function: PlotButton
        function PlotButtonPushed(app, event)
            DPDisplay(app,"plot");
        end

        % Button pushed function: MovetoWorkspacePDButton
        function MovetoWorkspacePDButtonPushed(app, event)
            assignin("base","PDdata",app.PDdata);
        end

        % Button pushed function: RemoveButton
        function RemoveButtonPushed(app, event)
            
            try
                idxList = app.ObservationsListBox.Value;
            catch ME
                return
            end
            
            if isempty(idxList)
                return
            end
            
            app.PDdata(idxList) = [];
            RefreshPDList(app);
            
        end

        % Button pushed function: LoadPDButton
        function LoadPDButtonPushed(app, event)
            [filename, filepath] = uigetfile('*.mat');
            
            if isequal(filename,0)||isequal(filepath,0)
                return;
            end
            
            fullfile = strcat(filepath,filename);
            app.SystemStatusLabel.Text = 'Project loading...';
            drawnow
            
            DPdataNum = size(app.PDdata,2);
                                   
%             clearMemory(app);
            load(fullfile);
            AddNum = size(PDdata,2);
            
            if DPdataNum == 0
                app.PDdata = PDdata;
            else
                app.PDdata(DPdataNum+1:DPdataNum+AddNum) = PDdata;
            end
            
            app.ObservationsListBox.Items(DPdataNum+1:DPdataNum+AddNum) = ItemList;
            app.ObservationsListBox.ItemsData = (1:DPdataNum + AddNum);
            
%             updateBatchList(app);
            app.SystemStatusLabel.Text = 'Project loaded.';
        end

        % Button pushed function: SavePDButton
        function SavePDButtonPushed(app, event)
            filter = {'*.mat';'*.*'};
            [filename, filepath] = uiputfile(filter);
            
            if isequal(filename,0)||isequal(filepath,0)
                return;          
            end
            
            fullfile = strcat(filepath,filename);
            app.StatusLabel.Text = 'Project saving...';
            drawnow
            
            PDdata = app.PDdata;
            ItemList = app.ObservationsListBox.Items;
            
            
            save(fullfile,'PDdata','ItemList');
            app.StatusLabel.Text = 'Project saved.';
        end

        % Button pushed function: AnimationButton
        function AnimationButtonPushed(app, event)
            DPDisplay(app,"animation");
        end

        % Button pushed function: MemoryResetButton
        function MemoryResetButtonPushed(app, event)
                question = "Do you want to clear this tab's data?";
                answer = questdlg(question,'Warning');
                
            if answer == 'Yes'
                app.ELdata = [];
                app.ELTemp = [];
                app.tableSelection_EL = [];
                app.isFiltering = false;
                app.isDistribution = false;
                app.UITable_EL.Data = [];
                RefreshELTable(app);
                app.SystemStatusLabel.Text = "Extracted line data are all removed";
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create PSDanalyserUIFigure and hide until all components are created
            app.PSDanalyserUIFigure = uifigure('Visible', 'off');
            app.PSDanalyserUIFigure.Position = [100 100 1086 752];
            app.PSDanalyserUIFigure.Name = 'PSDanalyser';
            app.PSDanalyserUIFigure.Resize = 'off';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.PSDanalyserUIFigure);
            app.TabGroup.Position = [22 18 1044 687];

            % Create ProcessFootageTab
            app.ProcessFootageTab = uitab(app.TabGroup);
            app.ProcessFootageTab.Title = 'Process Footage';

            % Create UIAxes
            app.UIAxes = uiaxes(app.ProcessFootageTab);
            title(app.UIAxes, 'Title')
            app.UIAxes.XTick = [];
            app.UIAxes.YTick = [];
            app.UIAxes.Box = 'on';
            app.UIAxes.Position = [45 115 553 529];

            % Create UITable
            app.UITable = uitable(app.ProcessFootageTab);
            app.UITable.ColumnName = {'File'; 'Time (s)'; 'Frame Number'; 'Start Frame'};
            app.UITable.RowName = {};
            app.UITable.CellSelectionCallback = createCallbackFcn(app, @UITableCellSelection, true);
            app.UITable.Position = [638 232 391 271];

            % Create FootageInformationPanel
            app.FootageInformationPanel = uipanel(app.ProcessFootageTab);
            app.FootageInformationPanel.Title = 'Footage Information';
            app.FootageInformationPanel.Position = [637 510 391 137];

            % Create FramePerSecondEditFieldLabel
            app.FramePerSecondEditFieldLabel = uilabel(app.FootageInformationPanel);
            app.FramePerSecondEditFieldLabel.HorizontalAlignment = 'right';
            app.FramePerSecondEditFieldLabel.Position = [5 89 106 22];
            app.FramePerSecondEditFieldLabel.Text = 'Frame Per Second';

            % Create FramePerSecondEditField
            app.FramePerSecondEditField = uieditfield(app.FootageInformationPanel, 'numeric');
            app.FramePerSecondEditField.ValueDisplayFormat = '%5.2f';
            app.FramePerSecondEditField.Position = [134 89 54 22];

            % Create TotalFrameNumberEditFieldLabel
            app.TotalFrameNumberEditFieldLabel = uilabel(app.FootageInformationPanel);
            app.TotalFrameNumberEditFieldLabel.HorizontalAlignment = 'right';
            app.TotalFrameNumberEditFieldLabel.Position = [2 35 115 22];
            app.TotalFrameNumberEditFieldLabel.Text = 'Total Frame Number';

            % Create TotalFrameNumberEditField
            app.TotalFrameNumberEditField = uieditfield(app.FootageInformationPanel, 'numeric');
            app.TotalFrameNumberEditField.ValueDisplayFormat = '%.0f';
            app.TotalFrameNumberEditField.Position = [134 35 55 22];

            % Create TotalFootageTimesEditFieldLabel
            app.TotalFootageTimesEditFieldLabel = uilabel(app.FootageInformationPanel);
            app.TotalFootageTimesEditFieldLabel.HorizontalAlignment = 'right';
            app.TotalFootageTimesEditFieldLabel.Position = [191 35 125 22];
            app.TotalFootageTimesEditFieldLabel.Text = 'Total Footage Time (s)';

            % Create TotalFootageTimesEditField
            app.TotalFootageTimesEditField = uieditfield(app.FootageInformationPanel, 'numeric');
            app.TotalFootageTimesEditField.ValueDisplayFormat = '%5.2f';
            app.TotalFootageTimesEditField.Position = [321 35 60 22];

            % Create MeasurementDateEditFieldLabel
            app.MeasurementDateEditFieldLabel = uilabel(app.FootageInformationPanel);
            app.MeasurementDateEditFieldLabel.HorizontalAlignment = 'right';
            app.MeasurementDateEditFieldLabel.Position = [4 8 107 22];
            app.MeasurementDateEditFieldLabel.Text = 'Measurement Date';

            % Create MeasurementDateEditField
            app.MeasurementDateEditField = uieditfield(app.FootageInformationPanel, 'text');
            app.MeasurementDateEditField.HorizontalAlignment = 'center';
            app.MeasurementDateEditField.Position = [134 8 248 22];

            % Create HydrationStartFrameEditFieldLabel
            app.HydrationStartFrameEditFieldLabel = uilabel(app.FootageInformationPanel);
            app.HydrationStartFrameEditFieldLabel.HorizontalAlignment = 'right';
            app.HydrationStartFrameEditFieldLabel.Position = [5 62 124 22];
            app.HydrationStartFrameEditFieldLabel.Text = 'Hydration Start Frame';

            % Create HydrationStartFrameEditField
            app.HydrationStartFrameEditField = uieditfield(app.FootageInformationPanel, 'numeric');
            app.HydrationStartFrameEditField.ValueDisplayFormat = '%.0f';
            app.HydrationStartFrameEditField.Position = [134 62 54 22];
            app.HydrationStartFrameEditField.Value = 1;

            % Create DisplayHSTFrameButton
            app.DisplayHSTFrameButton = uibutton(app.FootageInformationPanel, 'push');
            app.DisplayHSTFrameButton.ButtonPushedFcn = createCallbackFcn(app, @DisplayHSTFrameButtonPushed, true);
            app.DisplayHSTFrameButton.Position = [202 62 89 22];
            app.DisplayHSTFrameButton.Text = 'Display';

            % Create ApplyFPSButton
            app.ApplyFPSButton = uibutton(app.FootageInformationPanel, 'push');
            app.ApplyFPSButton.ButtonPushedFcn = createCallbackFcn(app, @ApplyFPSButtonPushed, true);
            app.ApplyFPSButton.Position = [202 89 89 22];
            app.ApplyFPSButton.Text = 'Apply';

            % Create RemoveSelectedButton
            app.RemoveSelectedButton = uibutton(app.ProcessFootageTab, 'push');
            app.RemoveSelectedButton.ButtonPushedFcn = createCallbackFcn(app, @RemoveSelectedButtonPushed, true);
            app.RemoveSelectedButton.Position = [917 203 105 22];
            app.RemoveSelectedButton.Text = 'Remove Selected';

            % Create PlaySelectedButton
            app.PlaySelectedButton = uibutton(app.ProcessFootageTab, 'push');
            app.PlaySelectedButton.ButtonPushedFcn = createCallbackFcn(app, @PlaySelectedButtonPushed, true);
            app.PlaySelectedButton.Position = [821 203 90 22];
            app.PlaySelectedButton.Text = 'Play Selected';

            % Create DisplayPanel
            app.DisplayPanel = uipanel(app.ProcessFootageTab);
            app.DisplayPanel.Title = 'Display';
            app.DisplayPanel.Position = [13 11 1015 95];

            % Create PlayButton
            app.PlayButton = uibutton(app.DisplayPanel, 'push');
            app.PlayButton.ButtonPushedFcn = createCallbackFcn(app, @PlayButtonPushed, true);
            app.PlayButton.Position = [871 40 123 24];
            app.PlayButton.Text = 'Play';

            % Create FrameEditFieldLabel
            app.FrameEditFieldLabel = uilabel(app.DisplayPanel);
            app.FrameEditFieldLabel.HorizontalAlignment = 'right';
            app.FrameEditFieldLabel.Position = [646 41 40 22];
            app.FrameEditFieldLabel.Text = 'Frame';

            % Create FrameEditField
            app.FrameEditField = uieditfield(app.DisplayPanel, 'numeric');
            app.FrameEditField.ValueDisplayFormat = '%.0f';
            app.FrameEditField.ValueChangedFcn = createCallbackFcn(app, @FrameEditFieldValueChanged, true);
            app.FrameEditField.Position = [691 41 60 22];

            % Create TimesEditFieldLabel
            app.TimesEditFieldLabel = uilabel(app.DisplayPanel);
            app.TimesEditFieldLabel.HorizontalAlignment = 'right';
            app.TimesEditFieldLabel.Position = [750 41 47 22];
            app.TimesEditFieldLabel.Text = 'Time (s)';

            % Create TimesEditField
            app.TimesEditField = uieditfield(app.DisplayPanel, 'numeric');
            app.TimesEditField.ValueDisplayFormat = '%5.2f';
            app.TimesEditField.Position = [801 41 52 22];

            % Create Backward1Button
            app.Backward1Button = uibutton(app.DisplayPanel, 'push');
            app.Backward1Button.ButtonPushedFcn = createCallbackFcn(app, @Backward1ButtonPushed, true);
            app.Backward1Button.Position = [706 9 44 28];
            app.Backward1Button.Text = '-1';

            % Create Forward1Button
            app.Forward1Button = uibutton(app.DisplayPanel, 'push');
            app.Forward1Button.ButtonPushedFcn = createCallbackFcn(app, @Forward1ButtonPushed, true);
            app.Forward1Button.Position = [757 9 44 28];
            app.Forward1Button.Text = '+1';

            % Create Forward10Button
            app.Forward10Button = uibutton(app.DisplayPanel, 'push');
            app.Forward10Button.ButtonPushedFcn = createCallbackFcn(app, @Forward10ButtonPushed, true);
            app.Forward10Button.Position = [810 9 44 28];
            app.Forward10Button.Text = '+10';

            % Create Backward10Button
            app.Backward10Button = uibutton(app.DisplayPanel, 'push');
            app.Backward10Button.ButtonPushedFcn = createCallbackFcn(app, @Backward10ButtonPushed, true);
            app.Backward10Button.Position = [653 9 44 28];
            app.Backward10Button.Text = '-10';

            % Create StopButton
            app.StopButton = uibutton(app.DisplayPanel, 'push');
            app.StopButton.ButtonPushedFcn = createCallbackFcn(app, @StopButtonPushed, true);
            app.StopButton.Position = [871 10 126 24];
            app.StopButton.Text = 'Stop';

            % Create FrameSliderLabel
            app.FrameSliderLabel = uilabel(app.DisplayPanel);
            app.FrameSliderLabel.HorizontalAlignment = 'right';
            app.FrameSliderLabel.Position = [9 47 40 22];
            app.FrameSliderLabel.Text = 'Frame';

            % Create FrameSlider
            app.FrameSlider = uislider(app.DisplayPanel);
            app.FrameSlider.ValueChangedFcn = createCallbackFcn(app, @FrameSliderValueChanged, true);
            app.FrameSlider.ValueChangingFcn = createCallbackFcn(app, @FrameSliderValueChanging, true);
            app.FrameSlider.Position = [13 39 613 3];

            % Create LineExtractionPanel
            app.LineExtractionPanel = uipanel(app.ProcessFootageTab);
            app.LineExtractionPanel.Title = 'Line Extraction';
            app.LineExtractionPanel.Position = [637 115 391 80];

            % Create LinePositionpixelEditFieldLabel
            app.LinePositionpixelEditFieldLabel = uilabel(app.LineExtractionPanel);
            app.LinePositionpixelEditFieldLabel.HorizontalAlignment = 'right';
            app.LinePositionpixelEditFieldLabel.Position = [71 33 109 22];
            app.LinePositionpixelEditFieldLabel.Text = 'Line Position (pixel)';

            % Create LinePositionpixelEditField
            app.LinePositionpixelEditField = uieditfield(app.LineExtractionPanel, 'numeric');
            app.LinePositionpixelEditField.Limits = [1 Inf];
            app.LinePositionpixelEditField.ValueDisplayFormat = '%.0f';
            app.LinePositionpixelEditField.ValueChangedFcn = createCallbackFcn(app, @LinePositionpixelEditFieldValueChanged, true);
            app.LinePositionpixelEditField.Position = [182 33 35 22];
            app.LinePositionpixelEditField.Value = 1;

            % Create ExtractButton
            app.ExtractButton = uibutton(app.LineExtractionPanel, 'push');
            app.ExtractButton.ButtonPushedFcn = createCallbackFcn(app, @ExtractButtonPushed, true);
            app.ExtractButton.Position = [309 8 74 44];
            app.ExtractButton.Text = 'Extract';

            % Create EnableButton
            app.EnableButton = uibutton(app.LineExtractionPanel, 'state');
            app.EnableButton.ValueChangedFcn = createCallbackFcn(app, @EnableButtonValueChanged, true);
            app.EnableButton.Text = 'Enable';
            app.EnableButton.Position = [13 8 53 44];

            % Create Yplus10Button
            app.Yplus10Button = uibutton(app.LineExtractionPanel, 'push');
            app.Yplus10Button.ButtonPushedFcn = createCallbackFcn(app, @Yplus10ButtonPushed, true);
            app.Yplus10Button.Position = [239 6 63 22];
            app.Yplus10Button.Text = 'Down 10';

            % Create Yplus1Button
            app.Yplus1Button = uibutton(app.LineExtractionPanel, 'push');
            app.Yplus1Button.ButtonPushedFcn = createCallbackFcn(app, @Yplus1ButtonPushed, true);
            app.Yplus1Button.Position = [184 6 54 22];
            app.Yplus1Button.Text = 'Down 1';

            % Create Yminus1Button
            app.Yminus1Button = uibutton(app.LineExtractionPanel, 'push');
            app.Yminus1Button.ButtonPushedFcn = createCallbackFcn(app, @Yminus1ButtonPushed, true);
            app.Yminus1Button.Position = [128 6 54 22];
            app.Yminus1Button.Text = 'up 1';

            % Create Yminus10Button
            app.Yminus10Button = uibutton(app.LineExtractionPanel, 'push');
            app.Yminus10Button.ButtonPushedFcn = createCallbackFcn(app, @Yminus10ButtonPushed, true);
            app.Yminus10Button.Position = [72 6 54 22];
            app.Yminus10Button.Text = 'up 10';

            % Create MultiDropDownLabel
            app.MultiDropDownLabel = uilabel(app.LineExtractionPanel);
            app.MultiDropDownLabel.HorizontalAlignment = 'right';
            app.MultiDropDownLabel.Position = [217 33 31 22];
            app.MultiDropDownLabel.Text = 'Multi';

            % Create MultiDropDown
            app.MultiDropDown = uidropdown(app.LineExtractionPanel);
            app.MultiDropDown.Items = {'1', '2', '3', '4', '5'};
            app.MultiDropDown.Position = [255 33 43 22];
            app.MultiDropDown.Value = '2';

            % Create ImageSizepixelEditFieldLabel
            app.ImageSizepixelEditFieldLabel = uilabel(app.ProcessFootageTab);
            app.ImageSizepixelEditFieldLabel.HorizontalAlignment = 'right';
            app.ImageSizepixelEditFieldLabel.Position = [641 203 99 22];
            app.ImageSizepixelEditFieldLabel.Text = 'Image Size (pixel)';

            % Create ImageSizepixelEditField
            app.ImageSizepixelEditField = uieditfield(app.ProcessFootageTab, 'text');
            app.ImageSizepixelEditField.Position = [747 203 65 22];

            % Create ExtractedLinesTab
            app.ExtractedLinesTab = uitab(app.TabGroup);
            app.ExtractedLinesTab.Title = 'Extracted Lines';

            % Create UIAxes_EL
            app.UIAxes_EL = uiaxes(app.ExtractedLinesTab);
            title(app.UIAxes_EL, 'Title')
            app.UIAxes_EL.XTick = [];
            app.UIAxes_EL.YTick = [];
            app.UIAxes_EL.Box = 'on';
            app.UIAxes_EL.Position = [18 224 1002 412];

            % Create UITable_EL
            app.UITable_EL = uitable(app.ExtractedLinesTab);
            app.UITable_EL.ColumnName = {'Project'; 'Position'; 'Number'; 'Run Time'; 'Binary'};
            app.UITable_EL.ColumnWidth = {150, 62, 60, 70, 'auto'};
            app.UITable_EL.RowName = {};
            app.UITable_EL.CellSelectionCallback = createCallbackFcn(app, @UITable_ELCellSelection, true);
            app.UITable_EL.Position = [321 52 408 156];

            % Create EL_F_Button
            app.EL_F_Button = uibutton(app.ExtractedLinesTab, 'push');
            app.EL_F_Button.ButtonPushedFcn = createCallbackFcn(app, @EL_F_ButtonPushed, true);
            app.EL_F_Button.Position = [169 141 65 30];
            app.EL_F_Button.Text = '>';

            % Create EL_B_Button
            app.EL_B_Button = uibutton(app.ExtractedLinesTab, 'push');
            app.EL_B_Button.ButtonPushedFcn = createCallbackFcn(app, @EL_B_ButtonPushed, true);
            app.EL_B_Button.Position = [97 141 65 30];
            app.EL_B_Button.Text = '<';

            % Create fromEditFieldLabel
            app.fromEditFieldLabel = uilabel(app.ExtractedLinesTab);
            app.fromEditFieldLabel.HorizontalAlignment = 'right';
            app.fromEditFieldLabel.Position = [137 182 29 22];
            app.fromEditFieldLabel.Text = 'from';

            % Create fromEditField
            app.fromEditField = uieditfield(app.ExtractedLinesTab, 'numeric');
            app.fromEditField.ValueDisplayFormat = '%5.2f';
            app.fromEditField.Position = [171 182 51 22];

            % Create toEditFieldLabel
            app.toEditFieldLabel = uilabel(app.ExtractedLinesTab);
            app.toEditFieldLabel.HorizontalAlignment = 'right';
            app.toEditFieldLabel.Position = [213 182 25 22];
            app.toEditFieldLabel.Text = 'to';

            % Create toEditField
            app.toEditField = uieditfield(app.ExtractedLinesTab, 'numeric');
            app.toEditField.ValueDisplayFormat = '%5.2f';
            app.toEditField.Position = [243 182 58 22];

            % Create DisplayRangesecLabel
            app.DisplayRangesecLabel = uilabel(app.ExtractedLinesTab);
            app.DisplayRangesecLabel.Position = [29 182 117 22];
            app.DisplayRangesecLabel.Text = 'Display Range (sec):';

            % Create EL_FF_Button
            app.EL_FF_Button = uibutton(app.ExtractedLinesTab, 'push');
            app.EL_FF_Button.ButtonPushedFcn = createCallbackFcn(app, @EL_FF_ButtonPushed, true);
            app.EL_FF_Button.Position = [240 141 65 30];
            app.EL_FF_Button.Text = '>>';

            % Create EL_BB_Button
            app.EL_BB_Button = uibutton(app.ExtractedLinesTab, 'push');
            app.EL_BB_Button.ButtonPushedFcn = createCallbackFcn(app, @EL_BB_ButtonPushed, true);
            app.EL_BB_Button.Position = [25 141 65 30];
            app.EL_BB_Button.Text = '<<';

            % Create ScaleDownButton
            app.ScaleDownButton = uibutton(app.ExtractedLinesTab, 'push');
            app.ScaleDownButton.ButtonPushedFcn = createCallbackFcn(app, @ScaleDownButtonPushed, true);
            app.ScaleDownButton.Position = [25 108 137 25];
            app.ScaleDownButton.Text = 'Scale Down';

            % Create ScaleUpButton
            app.ScaleUpButton = uibutton(app.ExtractedLinesTab, 'push');
            app.ScaleUpButton.ButtonPushedFcn = createCallbackFcn(app, @ScaleUpButtonPushed, true);
            app.ScaleUpButton.Position = [169 109 137 25];
            app.ScaleUpButton.Text = 'Scale Up';

            % Create RemoveSelectedButton_2
            app.RemoveSelectedButton_2 = uibutton(app.ExtractedLinesTab, 'push');
            app.RemoveSelectedButton_2.ButtonPushedFcn = createCallbackFcn(app, @RemoveSelectedButton_2Pushed, true);
            app.RemoveSelectedButton_2.Position = [329 12 122 28];
            app.RemoveSelectedButton_2.Text = 'Remove Selected';

            % Create MovetoWorkspaceButton
            app.MovetoWorkspaceButton = uibutton(app.ExtractedLinesTab, 'push');
            app.MovetoWorkspaceButton.ButtonPushedFcn = createCallbackFcn(app, @MovetoWorkspaceButtonPushed, true);
            app.MovetoWorkspaceButton.Position = [460 12 122 28];
            app.MovetoWorkspaceButton.Text = 'Move to Workspace';

            % Create LoadButton
            app.LoadButton = uibutton(app.ExtractedLinesTab, 'push');
            app.LoadButton.ButtonPushedFcn = createCallbackFcn(app, @LoadButtonPushed, true);
            app.LoadButton.Position = [591 12 61 28];
            app.LoadButton.Text = 'Load';

            % Create SaveButton
            app.SaveButton = uibutton(app.ExtractedLinesTab, 'push');
            app.SaveButton.ButtonPushedFcn = createCallbackFcn(app, @SaveButtonPushed, true);
            app.SaveButton.Position = [660 12 61 28];
            app.SaveButton.Text = 'Save';

            % Create DichotomisationPanel
            app.DichotomisationPanel = uipanel(app.ExtractedLinesTab);
            app.DichotomisationPanel.Title = 'Dichotomisation';
            app.DichotomisationPanel.Position = [747 105 276 103];

            % Create SigmaDropDownLabel
            app.SigmaDropDownLabel = uilabel(app.DichotomisationPanel);
            app.SigmaDropDownLabel.HorizontalAlignment = 'right';
            app.SigmaDropDownLabel.Position = [14 49 40 22];
            app.SigmaDropDownLabel.Text = 'Sigma';

            % Create SigmaDropDown
            app.SigmaDropDown = uidropdown(app.DichotomisationPanel);
            app.SigmaDropDown.Items = {'1', '2', '3', '4'};
            app.SigmaDropDown.Position = [60 49 47 22];
            app.SigmaDropDown.Value = '1';

            % Create GaussianBlurButton
            app.GaussianBlurButton = uibutton(app.DichotomisationPanel, 'push');
            app.GaussianBlurButton.ButtonPushedFcn = createCallbackFcn(app, @GaussianBlurButtonPushed, true);
            app.GaussianBlurButton.Position = [119 46 86 28];
            app.GaussianBlurButton.Text = 'Gaussian Blur';

            % Create DichotomiseButton
            app.DichotomiseButton = uibutton(app.DichotomisationPanel, 'push');
            app.DichotomiseButton.ButtonPushedFcn = createCallbackFcn(app, @DichotomiseButtonPushed, true);
            app.DichotomiseButton.Position = [118 8 86 28];
            app.DichotomiseButton.Text = 'Dichotomise';

            % Create SaveButton_2
            app.SaveButton_2 = uibutton(app.DichotomisationPanel, 'push');
            app.SaveButton_2.ButtonPushedFcn = createCallbackFcn(app, @SaveButton_2Pushed, true);
            app.SaveButton_2.Position = [211 8 57 28];
            app.SaveButton_2.Text = 'Save';

            % Create ThresholdSpinnerLabel
            app.ThresholdSpinnerLabel = uilabel(app.DichotomisationPanel);
            app.ThresholdSpinnerLabel.HorizontalAlignment = 'right';
            app.ThresholdSpinnerLabel.Position = [-2 11 59 22];
            app.ThresholdSpinnerLabel.Text = 'Threshold';

            % Create ThresholdSpinner
            app.ThresholdSpinner = uispinner(app.DichotomisationPanel);
            app.ThresholdSpinner.Limits = [0 255];
            app.ThresholdSpinner.Position = [61 11 55 22];
            app.ThresholdSpinner.Value = 200;

            % Create ReturnButton
            app.ReturnButton = uibutton(app.DichotomisationPanel, 'push');
            app.ReturnButton.ButtonPushedFcn = createCallbackFcn(app, @ReturnButtonPushed, true);
            app.ReturnButton.Position = [210 46 57 28];
            app.ReturnButton.Text = 'Return';

            % Create ImageAnalysisPanel
            app.ImageAnalysisPanel = uipanel(app.ExtractedLinesTab);
            app.ImageAnalysisPanel.Title = 'Image Analysis';
            app.ImageAnalysisPanel.Position = [747 11 276 80];

            % Create ParticleAnalysisButton
            app.ParticleAnalysisButton = uibutton(app.ImageAnalysisPanel, 'push');
            app.ParticleAnalysisButton.ButtonPushedFcn = createCallbackFcn(app, @ParticleAnalysisButtonPushed, true);
            app.ParticleAnalysisButton.Position = [18 10 242 38];
            app.ParticleAnalysisButton.Text = 'Particle Analysis';

            % Create MemoryResetButton
            app.MemoryResetButton = uibutton(app.ExtractedLinesTab, 'push');
            app.MemoryResetButton.ButtonPushedFcn = createCallbackFcn(app, @MemoryResetButtonPushed, true);
            app.MemoryResetButton.Position = [22 12 122 28];
            app.MemoryResetButton.Text = 'Memory Reset';

            % Create ParticleDistributionTab
            app.ParticleDistributionTab = uitab(app.TabGroup);
            app.ParticleDistributionTab.Title = 'Particle Distribution';

            % Create UIAxes_PD
            app.UIAxes_PD = uiaxes(app.ParticleDistributionTab);
            xlabel(app.UIAxes_PD, 'Time (s)')
            ylabel(app.UIAxes_PD, 'Particle Size (pixel)')
            zlabel(app.UIAxes_PD, 'Z')
            app.UIAxes_PD.PlotBoxAspectRatio = [2.58536585365854 1 1];
            app.UIAxes_PD.Box = 'on';
            app.UIAxes_PD.Position = [20 217 1003 425];

            % Create UIAxes_PDH
            app.UIAxes_PDH = uiaxes(app.ParticleDistributionTab);
            title(app.UIAxes_PDH, 'Histogram')
            xlabel(app.UIAxes_PDH, 'Particle Size (pixel number)')
            ylabel(app.UIAxes_PDH, 'Count')
            zlabel(app.UIAxes_PDH, 'Z')
            app.UIAxes_PDH.Box = 'on';
            app.UIAxes_PDH.Position = [600 11 415 202];

            % Create ObservationsListBoxLabel
            app.ObservationsListBoxLabel = uilabel(app.ParticleDistributionTab);
            app.ObservationsListBoxLabel.HorizontalAlignment = 'right';
            app.ObservationsListBoxLabel.Position = [47 191 77 22];
            app.ObservationsListBoxLabel.Text = 'Observations';

            % Create ObservationsListBox
            app.ObservationsListBox = uilistbox(app.ParticleDistributionTab);
            app.ObservationsListBox.Items = {};
            app.ObservationsListBox.Multiselect = 'on';
            app.ObservationsListBox.Position = [46 48 223 141];
            app.ObservationsListBox.Value = {};

            % Create RemoveButton
            app.RemoveButton = uibutton(app.ParticleDistributionTab, 'push');
            app.RemoveButton.ButtonPushedFcn = createCallbackFcn(app, @RemoveButtonPushed, true);
            app.RemoveButton.Position = [53 15 75 25];
            app.RemoveButton.Text = 'Remove';

            % Create LoadPDButton
            app.LoadPDButton = uibutton(app.ParticleDistributionTab, 'push');
            app.LoadPDButton.ButtonPushedFcn = createCallbackFcn(app, @LoadPDButtonPushed, true);
            app.LoadPDButton.Position = [139 15 58 25];
            app.LoadPDButton.Text = 'Load';

            % Create SavePDButton
            app.SavePDButton = uibutton(app.ParticleDistributionTab, 'push');
            app.SavePDButton.ButtonPushedFcn = createCallbackFcn(app, @SavePDButtonPushed, true);
            app.SavePDButton.Position = [204 15 58 25];
            app.SavePDButton.Text = 'Save';

            % Create PlotButton
            app.PlotButton = uibutton(app.ParticleDistributionTab, 'push');
            app.PlotButton.ButtonPushedFcn = createCallbackFcn(app, @PlotButtonPushed, true);
            app.PlotButton.Position = [289 97 146 34];
            app.PlotButton.Text = 'Plot';

            % Create MovetoWorkspacePDButton
            app.MovetoWorkspacePDButton = uibutton(app.ParticleDistributionTab, 'push');
            app.MovetoWorkspacePDButton.ButtonPushedFcn = createCallbackFcn(app, @MovetoWorkspacePDButtonPushed, true);
            app.MovetoWorkspacePDButton.Position = [289 17 146 25];
            app.MovetoWorkspacePDButton.Text = 'Move to Workspace';

            % Create LegendCheckBox
            app.LegendCheckBox = uicheckbox(app.ParticleDistributionTab);
            app.LegendCheckBox.Text = 'Legend';
            app.LegendCheckBox.Position = [294 165 62 22];

            % Create TotalBinCountEditFieldLabel
            app.TotalBinCountEditFieldLabel = uilabel(app.ParticleDistributionTab);
            app.TotalBinCountEditFieldLabel.HorizontalAlignment = 'right';
            app.TotalBinCountEditFieldLabel.Position = [445 18 88 22];
            app.TotalBinCountEditFieldLabel.Text = 'Total Bin Count';

            % Create TotalBinCountEditField
            app.TotalBinCountEditField = uieditfield(app.ParticleDistributionTab, 'numeric');
            app.TotalBinCountEditField.ValueDisplayFormat = '%.0f';
            app.TotalBinCountEditField.Position = [538 18 57 22];

            % Create AnimationButton
            app.AnimationButton = uibutton(app.ParticleDistributionTab, 'push');
            app.AnimationButton.ButtonPushedFcn = createCallbackFcn(app, @AnimationButtonPushed, true);
            app.AnimationButton.Position = [289 58 146 33];
            app.AnimationButton.Text = 'Animation';

            % Create DataDropDownLabel
            app.DataDropDownLabel = uilabel(app.ParticleDistributionTab);
            app.DataDropDownLabel.HorizontalAlignment = 'right';
            app.DataDropDownLabel.Position = [289 139 31 22];
            app.DataDropDownLabel.Text = 'Data';

            % Create DataDropDown
            app.DataDropDown = uidropdown(app.ParticleDistributionTab);
            app.DataDropDown.Items = {'Spatial', 'Temporal', 'Cumulative'};
            app.DataDropDown.Position = [335 139 100 22];
            app.DataDropDown.Value = 'Spatial';

            % Create GridCheckBox
            app.GridCheckBox = uicheckbox(app.ParticleDistributionTab);
            app.GridCheckBox.Text = 'Grid';
            app.GridCheckBox.Position = [364 167 45 22];

            % Create Load1stTiffButton
            app.Load1stTiffButton = uibutton(app.PSDanalyserUIFigure, 'push');
            app.Load1stTiffButton.ButtonPushedFcn = createCallbackFcn(app, @Load1stTiffButtonPushed, true);
            app.Load1stTiffButton.Position = [22 717 100 22];
            app.Load1stTiffButton.Text = 'Load 1st Tiff';

            % Create ProjectEditFieldLabel
            app.ProjectEditFieldLabel = uilabel(app.PSDanalyserUIFigure);
            app.ProjectEditFieldLabel.HorizontalAlignment = 'right';
            app.ProjectEditFieldLabel.Position = [125 717 47 22];
            app.ProjectEditFieldLabel.Text = 'Project:';

            % Create ProjectEditField
            app.ProjectEditField = uieditfield(app.PSDanalyserUIFigure, 'text');
            app.ProjectEditField.Position = [179 717 216 22];

            % Create ImportDataButton
            app.ImportDataButton = uibutton(app.PSDanalyserUIFigure, 'push');
            app.ImportDataButton.ButtonPushedFcn = createCallbackFcn(app, @ImportDataButtonPushed, true);
            app.ImportDataButton.Position = [412 717 100 22];
            app.ImportDataButton.Text = 'Import Data';

            % Create StatusLabel
            app.StatusLabel = uilabel(app.PSDanalyserUIFigure);
            app.StatusLabel.Position = [767 717 51 22];
            app.StatusLabel.Text = 'Status:';

            % Create SystemStatusLabel
            app.SystemStatusLabel = uilabel(app.PSDanalyserUIFigure);
            app.SystemStatusLabel.Position = [819 717 238 22];
            app.SystemStatusLabel.Text = '';

            % Create ColormapDropDownLabel
            app.ColormapDropDownLabel = uilabel(app.PSDanalyserUIFigure);
            app.ColormapDropDownLabel.HorizontalAlignment = 'right';
            app.ColormapDropDownLabel.Position = [513 717 58 22];
            app.ColormapDropDownLabel.Text = 'Colormap';

            % Create ColormapDropDown
            app.ColormapDropDown = uidropdown(app.PSDanalyserUIFigure);
            app.ColormapDropDown.Items = {'gray', 'bone', 'copper'};
            app.ColormapDropDown.Position = [575 717 84 22];
            app.ColormapDropDown.Value = 'gray';

            % Create ColorbarCheckBox
            app.ColorbarCheckBox = uicheckbox(app.PSDanalyserUIFigure);
            app.ColorbarCheckBox.Text = 'Colorbar';
            app.ColorbarCheckBox.Position = [668 717 69 22];

            % Show the figure after all components are created
            app.PSDanalyserUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = PSDanalyser_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.PSDanalyserUIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.PSDanalyserUIFigure)
        end
    end
end