clear all
close all
clc


commandwindow;

% %% TRIGGER DAQ setup
% portNum = 0; %Choose device port to use 0=A, 1=B
% % triggerValue = 1; %0-255, or use e.g. bin2dec('00010100') to more easily control individual lines.  Rightmost digit would be rightmost wire on the port.
% 
% %find device
% daqInd=DaqDeviceIndex;  %Scans USB-HID device list, returns index number for the USB DAQ.
% HIDDevices=PsychHID('Devices');    %not generally used, but good for debugging if device is not found by DaqDeviceIndex.m
% %initialize device
% DaqDConfigPort(daqInd(1),0,0); % set digital port A's mode to output
% DaqDConfigPort(daqInd(1),1,0); % same for B
% DaqDOut(daqInd(1),0,0);	%set A and B to zero
% DaqDOut(daqInd(1),1,0);

%% Initialization

load('Vignettes.mat');

% Screen setup
black = [0 0 0];
grey = [128 128 128];
white = [255 255 255];

[w,winRect]=Screen('OpenWindow',0, grey);

Time_OpenWindow = GetSecs;
% Send_TRIGGER(daqInd, 64);  %%%%%%%%%
% Send_TRIGGER(daqInd, 128);


HideCursor;


Screen('Preference', 'SkipSyncTests', 1)
Screen('Preference', 'VisualDebugLevel', 1);
Screen('TextSize', w, 27);
Screen('TextFont',w,'Times');
Screen('TextStyle',w,1);


% %% Do EyeLink Preparation
% %%  PARAMETERS
% eyetrackYN = true; %do you want eye tracking?
% liveDisplayYN = false;  %draw eye tracking in experimenter monitor?.
% % 
% % faceFiledir = 'Faces/';
% % otherFiledir = 'Flowers/';
% % 
% dataFiledir = '';
% % faceListFile = 'faceList.txt';
% % 
% 
% 
% % 
% % %%  GET INFO
% % %find next stimList file number
% fileNum = 1;
% 
% 
% EyelinkFilename = 'test410';
% 
% %%  PREPARE
% 
% % black = [0 0 0];
% % white = [255 255 255];
% % [w,winRect]=Screen('OpenWindow',0, black);
% 
% if eyetrackYN
%     % Initialization of the connection with the Eyelink Gazetracker.
%     % exit program if this fails.
%     if EyelinkInit()~=1
%         sca
%         return;
%     end
%     
% 
%     el=EyelinkInitDefaults(w);
%     
%     % make sure that we get gaze data from the Eyelink
% %     EYELINK('command', 'link_sample_data = RIGHT,LEFT,GAZE,AREA');
%     % open file to record data to
%     Eyelink('openfile',[EyelinkFilename,'.edf']);
%     % Calibrate the eye tracker using the standard calibration routines
%     EyelinkDoTrackerSetup(el);
%     %disp('setup over, driftcorrecting')
%     % do a final check of calibration using driftcorrection
%     EyelinkDoDriftCorrection(el);
% %     FlushEvents('keydown')
% end

%% 
    % Shuffle item lists
    Order_Vignettes = randperm(size(Vignettes,1))';
    for i = 1:size(Order_Vignettes,1)
        Vignettes_Shuffle{i,1} = Vignettes{Order_Vignettes(i,1),1};
        Vignettes_Shuffle{i,2} = Vignettes{Order_Vignettes(i,1),2};
        Vignettes_Shuffle{i,3} = Vignettes{Order_Vignettes(i,1),3};
        Vignettes_Shuffle{i,4} = Vignettes{Order_Vignettes(i,1),4};
        Vignettes_Shuffle{i,5} = Vignettes{Order_Vignettes(i,1),5};
        
    end
    
message = {};

instruction = ['In this task you will read a series of short scenarios and answer four questions about each.\n'...
    '\n'...
    '\n'...
    'Please read the scenarios and the associated questions carefully.\n'...
    '\n'...
    '\n'...
    'Make sure to answer each question based on the information provided in the scenario.\n'...
    '\n'...
    '\n'...
    'To answer a question, simply press a number on the keyboard.\n'...
    '\n'...
    '\n'...
    'Please make sure you are responding to the scenario being displayed on the screen.\n'...
    '\n'...
    '\n'...
    '\n'...
    '\n'...
    '\n'...
    'Press the space bar to start!\n'];

DrawFormattedText(w, instruction, 'center', 'center', white) ;
Screen('Flip', w);

press = true;

while press
     [~, keyCode, ~] = KbPressWait;
     Press_Time = GetSecs;
     pressedKey = KbName(keyCode);
    
    if  (strcmpi(pressedKey, 'space') == 1)
        press = false;
    end
    
end   % while press

ST = [];
RT = [];
pressedKey = {};

%% Block starts

    for i = 1:size(Vignettes_Shuffle,1)    %% Trial loop
        message{i} = Vignettes_Shuffle{i,1};
        
        %% Questions

    Scale = ['\n'...
        '1                   2                   3                   4                   5                   6                   7\n'];

        
    Question1 = [ '\n'...
    num2str(Vignettes_Shuffle{i,5}) '''s behavior was ... \n'];
    
    VB = ['\n'...
    'Very bad\n'];                                      
    
    NGNB = ['\n'...
    'Neither good\n'... 
    '\n'...
    '  nor bad \n'];

    VG = ['\n'...
    'Very good\n'];    

     
    Question2 = [ '\n'...
    num2str(Vignettes_Shuffle{i,5}) ' should be punished.\n'];...

    SD = ['\n'...
    'Strongly\n'...
    '\n'...
     'disagree\n'];

    NAND = ['\n'...
        'Neither agree\n'... 
        '\n'...
        'nor disagree\n'];                                  
    
    SA = ['\n'...
    'Strongly\n'...
    '\n'...
    '   agree\n'];


    Question3 = [ '\n'...
    num2str(Vignettes_Shuffle{i,5}) '''s behavior is only wrong if nobody else does it.\n'];


    Question4 = [ '\n'...
    num2str(Vignettes_Shuffle{i,5}) '''s behavior is only wrong if it''s illegal.\n'];

        


        % Q1
        
        DrawFormattedText(w, message{i}, 'center', 0.2* winRect(4), white) ;
        DrawFormattedText(w, Question1, 0.1* winRect(3), 0.55* winRect(4), white) ;
        DrawFormattedText(w, Scale, 'center', 0.7* winRect(4), white) ;
        DrawFormattedText(w, VG, 0.075* winRect(3), 0.8* winRect(4), white) ;
        DrawFormattedText(w, NGNB, 'center', 0.8* winRect(4), white) ;
        DrawFormattedText(w, VB, 0.825* winRect(3), 0.8* winRect(4), white) ;
        
        Screen('Flip', w) ;
        
        ST(i,1) = GetSecs;
        
press1 = true;

while press1
     [~, keyCode, ~] = KbPressWait;
     Press_Time = GetSecs;
     pressedKey{i,1} = KbName(keyCode);
     RT(i,1) = GetSecs - ST(i,1);
    
    if  (strcmpi(pressedKey{i,1}, '1!') == 1)||(strcmpi(pressedKey{i,1}, '2@') == 1)||(strcmpi(pressedKey{i,1}, '3#') == 1)||(strcmpi(pressedKey{i,1}, '4$') == 1)||(strcmpi(pressedKey{i,1}, '5%') == 1)||(strcmpi(pressedKey{i,1}, '6^') == 1)||(strcmpi(pressedKey{i,1}, '7&') == 1)
        press1 = false;
    end
    
end   % while press1


        % Q2
        DrawFormattedText(w, message{i}, 'center', 0.2* winRect(4), white) ;
        DrawFormattedText(w, Question2, 0.1* winRect(3), 0.55* winRect(4), white) ;
        DrawFormattedText(w, Scale, 'center', 0.7* winRect(4), white) ;
        DrawFormattedText(w, SD, 0.09* winRect(3), 0.8* winRect(4), white) ;
        DrawFormattedText(w, NAND, 'center', 0.8* winRect(4), white) ;
        DrawFormattedText(w, SA, 0.825* winRect(3), 0.8* winRect(4), white) ;
        
        Screen('Flip', w) ;
        ST(i,2) = GetSecs;
        
        press2 = true;

while press2
     [~, keyCode, ~] = KbPressWait;
     Press_Time = GetSecs;
     pressedKey{i,2} = KbName(keyCode);
     RT(i,2) = GetSecs - ST(i,2);
    
    if  (strcmpi(pressedKey{i,2}, '1!') == 1)||(strcmpi(pressedKey{i,2}, '2@') == 1)||(strcmpi(pressedKey{i,2}, '3#') == 1)||(strcmpi(pressedKey{i,2}, '4$') == 1)||(strcmpi(pressedKey{i,2}, '5%') == 1)||(strcmpi(pressedKey{i,2}, '6^') == 1)||(strcmpi(pressedKey{i,2}, '7&') == 1)
        press2 = false;
    end
    
end   % while press2


% Q3
        DrawFormattedText(w, message{i}, 'center', 0.2* winRect(4), white) ;
        DrawFormattedText(w, Question3, 0.1* winRect(3), 0.55* winRect(4), white) ;
        DrawFormattedText(w, Scale, 'center', 0.7* winRect(4), white) ;
        DrawFormattedText(w, SD, 0.09* winRect(3), 0.8* winRect(4), white) ;
        DrawFormattedText(w, NAND, 'center', 0.8* winRect(4), white) ;
        DrawFormattedText(w, SA, 0.825* winRect(3), 0.8* winRect(4), white) ;
        
        Screen('Flip', w) ;
        ST(i,3) = GetSecs;
        
        press3 = true;

while press3
     [~, keyCode, ~] = KbPressWait;
     Press_Time = GetSecs;
     pressedKey{i,3} = KbName(keyCode);
     RT(i,3) = GetSecs - ST(i,3);
    
    if  (strcmpi(pressedKey{i,3}, '1!') == 1)||(strcmpi(pressedKey{i,3}, '2@') == 1)||(strcmpi(pressedKey{i,3}, '3#') == 1)||(strcmpi(pressedKey{i,3}, '4$') == 1)||(strcmpi(pressedKey{i,3}, '5%') == 1)||(strcmpi(pressedKey{i,3}, '6^') == 1)||(strcmpi(pressedKey{i,3}, '7&') == 1)
        press3 = false;
    end
    
end   % while press3


% Q4
        DrawFormattedText(w, message{i}, 'center', 0.2* winRect(4), white) ;
        DrawFormattedText(w, Question4, 0.1* winRect(3), 0.55* winRect(4), white) ;
        DrawFormattedText(w, Scale, 'center', 0.7* winRect(4), white) ;
        DrawFormattedText(w, SD, 0.09* winRect(3), 0.8* winRect(4), white) ;
        DrawFormattedText(w, NAND, 'center', 0.8* winRect(4), white) ;
        DrawFormattedText(w, SA, 0.825* winRect(3), 0.8* winRect(4), white) ;
        
        Screen('Flip', w) ;
        ST(i,4) = GetSecs;
        
        press4 = true;

while press4
     [~, keyCode, ~] = KbPressWait;
     Press_Time = GetSecs;
     pressedKey{i,4} = KbName(keyCode);
     RT(i,4) = GetSecs - ST(i,4);
    
    if  (strcmpi(pressedKey{i,4}, '1!') == 1)||(strcmpi(pressedKey{i,4}, '2@') == 1)||(strcmpi(pressedKey{i,4}, '3#') == 1)||(strcmpi(pressedKey{i,4}, '4$') == 1)||(strcmpi(pressedKey{i,4}, '5%') == 1)||(strcmpi(pressedKey{i,4}, '6^') == 1)||(strcmpi(pressedKey{i,4}, '7&') == 1)
        press4 = false;
    end
    
end   % while press4


 Screen('FillRect', w, grey, winRect);   
 Screen('Flip', w) ;
 WaitSecs(0.5);       


Results.Scenario_Order = Vignettes_Shuffle;
Results.Start_Time = ST;
Results.Response_Time = RT;
Results.Button_Pressed = pressedKey;

save Results
    end   %% Trial loop
    
    
%% Ending

message_end=[ '\n'...
    'Complete!\n'...
    '\n'...
    '\n'...
    'Thank you for your participation.\n'...
    '\n'...
    '\n'...
    'Press the space bar to exit.\n'];

DrawFormattedText(w, message_end, 'center', 'center' , white) ;
Screen('Flip', w) ;
WaitSecs(0.1);


press_end = true;

while press_end
    [~, keyCode, ~] = KbWait;
    
%     Send_TRIGGER(daqInd, 32)
%     Send_TRIGGER(daqInd, 128)
    
    pressedKey = KbName(keyCode) ;
    if  strcmpi(pressedKey, 'space') == 1
        press_end = false;
    end
    
end

save Results


Screen('CloseAll');
    
