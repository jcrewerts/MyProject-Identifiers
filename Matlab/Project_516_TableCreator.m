clc
clear all
close all
tic %timer
%% Find Mat File to Use

matFiles = dir(strcat(pwd,'\*.mat'));
matFname = {matFiles.name}';

%check if there is more than one .mat files
if(length(matFname) > 1)
    fsize = [matFiles.bytes];
    [~,n] = max(fsize);
    matFname = matFname{n};
else
    matFname = matFname{1};
end

AllData = load(matFname);

fname = fields(AllData);

% AvgSpeed = zeros(length(fname),1);
% Current = zeros(length(fname),1);
Configuration = strings(length(fname),1);
LS_Jam = strings(length(fname),1);
DriveFileName = strings(length(fname),1);
%% Create Array to hold STD, 250, and Avg Error

%% Process the File

for i = 1:length(fname);
    
   %% Process Individual Data 
   fprintf('Processing %0.0f of %0.0f\n',i,length(fname)) 
    
   %%DownSample For Each Data Point
   
   data = AllData.(fname{i}); %pull data from each seperate run
   d = data.CANsignals; %rename how we will pull data
    
   t = 0:1/25:floor(d.R2_Canopy.time(end)); %time step
   
   dx.t = t;
   
   
   %% Axiomatic/Hydraulics Signals
   
   dx.InletPressure = DownSampleData(d.InletTiltPressSensor.val,d.InletTiltPressSensor.time,t);
   dx.RightCylinderPressure = DownSampleData(d.Right_Tilit_Cycl_Press.val,d.Right_Tilit_Cycl_Press.time,t);
   dx.LeftCylinderPressure = DownSampleData(d.Left_Tilt_Cyl_Press.val,d.Left_Tilt_Cyl_Press.time,t);
   dx.RightStringPot = DownSampleData(d.Right_Tilt_String_Pot.val,d.Right_Tilt_String_Pot.time,t);
   dx.LeftStringPot = DownSampleData(d.Left_Tilt_String_Pot.val,d.Left_Tilt_String_Pot.time,t);
   
   
   %% Speed km/h
   dx.Speed = DownSampleData(d.CAN_NavigationBasedVehicleSpeed.val,d.CAN_NavigationBasedVehicleSpeed.time,t);

   %% Roll Rates
    %dx.BoomRollRate = GeneralFilter(DownSampleData(d.CAN_TARS_RollRate.val,d.CAN_TARS_RollRate.time,t));
    %dx.BoomRollAngle = GeneralFilter(DownSampleData(d.CAN_TARS_RollAngle.val,d.CAN_TARS_RollAngle.time,t));
    %dx.ChasisRoll = GeneralFilter(DownSampleData(d.ChassisRollRate.val,d.ChassisRollRate.time,t));
    
    %CAN TARS Bus
    dx.ChassisPitchRate = DownSampleData(d.CAN_TARS_PitchRate.val,d.CAN_TARS_PitchRate.time,t);
    dx.ChassisRollRate = DownSampleData(d.CAN_TARS_RollRate.val,d.CAN_TARS_RollRate.time,t);
    dx.ChassisYawRate = DownSampleData(d.CAN_TARS_YawRate.val,d.CAN_TARS_YawRate.time,t);
    
    %dx.ChassisRollAngle = DownSampleData(d.CAN_TARS_RollAngle.val,d.CAN_TARS_RollAngle.time,t)
    
    %% CenterFrame Roll
    
    %Centerframe Roll Rate Rot Pot
    dx.CenterFrameRollRate = DownSampleData(d.BoomRollRate.val,d.BoomRollRate.time,t); %Rotarty Potentiometer deg/sec
   
    %Center Frame Roll LVDT
    
    if(isfield(d,'BoomRollRaw'))
        dx.CenterFrameRoll = DownSampleData(d.BoomRollRaw.val,d.BoomRollRaw.time,t); %LVDT deg/sec
    else
        
        CFRoll = d.CFRollLVDT_mV.val.*LVDT__Slope + LVDT__Intercept;
        dx.CenterFrameRoll = DownSampleData(CFRoll,d.CFRollLVDT_mV.time,t);
    end
    
%% Chassis Roll Rate & Chasis Roll
    CRR = zeros(size(d.CAN_TARS_RollAngle.val));
    CR = d.CAN_TARS_RollAngle.val;
    for k = 2:length(CRR)
        CR(k) = (CR(k-1) *4 + d.CAN_TARS_RollAngle.val(k)) ./5;
        CRR(k) = (CRR(k-1) * 4 + (CR(k) - CR(k-1)).*100)./5;
    end
%     
%     dx.ChasisRollRate = DownSampleData(CRR,d.CAN_TARS_RollAngle.time,t);
     dx.ChassisRollAngle = DownSampleData(CR,d.CAN_TARS_RollAngle.time,t);
     
  %% Tire String Pots
    dx.RightFront = DownSampleData(d.FrontRightStrPot_mV.val,d.FrontRightStrPot_mV.time,t);
    dx.LeftFront = DownSampleData(d.FrontLeftStrPot_mV.val,d.FrontLeftStrPot_mV.time,t);
    dx.RightBack = DownSampleData(d.RearRightStrPot_mV.val,d.RearRightStrPot_mV.time,t);
    dx.LeftBack = DownSampleData(d.RearLeftStrPot_mV.val,d.RearLeftStrPot_mV.time,t);
   %% Filtered Positions
   dx.L2 = UBSfilter(DownSampleData(d.L2_Ground.val,d.L2_Ground.time,t));
   dx.R2 = UBSfilter(DownSampleData(d.R2_Ground.val,d.R2_Ground.time,t));
   dx.L1 = UBSfilter(DownSampleData(d.L1_Ground.val,d.L1_Ground.time,t));
   dx.R1 = UBSfilter(DownSampleData(d.R1_Ground.val,d.R1_Ground.time,t));
   
   %% Offsets
   dx.R1Offsets = DownSampleData(d.BT_ISU_R1_VerticleOffset.val,d.BT_ISU_R1_VerticleOffset.time,t);
   dx.R2Offsets = DownSampleData(d.BT_ISU_R2_VerticleOffset.val,d.BT_ISU_R2_VerticleOffset.time,t);
   dx.L1Offsets = DownSampleData(d.BT_ISU_R1_VerticleOffset.val,d.BT_ISU_R1_VerticleOffset.time,t);
   dx.L2Offsets = DownSampleData(d.BT_ISU_R2_VerticleOffset.val,d.BT_ISU_R2_VerticleOffset.time,t);

   %% DownSample Currents
   dx.Current = DownSampleData(d.BT_ISU_TiltValveRequest.val,d.BT_ISU_TiltValveRequest.time,t);
   dx.LeftTiltUp = DownSampleData(d.BT_ISUOUT_LeftTiltUp.val,d.BT_ISUOUT_LeftTiltUp.time,t);
   dx.LeftTiltDown = DownSampleData(d.BT_ISUOUT_LeftTiltDown.val,d.BT_ISUOUT_LeftTiltDown.time,t);
    
   dx.RightTiltDown = DownSampleData(d.BT_ISUOUT_RightTiltDown.val,d.BT_ISUOUT_RightTiltDown.time,t);
   dx.RightTiltUp = DownSampleData(d.BT_ISUOUT_RightTiltUp.val,d.BT_ISUOUT_RightTiltUp.time,t);

   %% Target Height
   dx.TargetHt_mm = data.MetaData.TargetHeight_in.*25.4+mean(d.BT_ISU_L2_VerticleOffset.val);
   
   %% Mode 1 = Ground 2 = Canopy
   dx.Mode = d.BT_ISU_SensorTargetMode.val(20);
   %% filter roll rates and angles
  
   %% create masks
         ew_mask = dx.Speed > 16.1;
         dx.t = dx.t';

         NESW_mask = dx.Speed > 16.1;
   %% Errors
     dx.ErrorR1 = (dx.R1 - (dx.R1Offsets) - dx.TargetHt_mm(1).*ones(size(dx.L1Offsets)));
     dx.ErrorR2 = (dx.R2 - (dx.R2Offsets) - dx.TargetHt_mm(1)*ones(size(dx.L1Offsets)));
     dx.ErrorL1 = (dx.L1 - (dx.L1Offsets) - dx.TargetHt_mm(1)*ones(size(dx.L1Offsets)));
     dx.ErrorL2 = (dx.L2 - (dx.L2Offsets) - dx.TargetHt_mm(1)*ones(size(dx.L1Offsets)));   
     
   
    %% Cylinder Pressures
    dx.RightTiltCylPressure = DownSampleData(d.Right_Tilit_Cycl_Press.val,d.Right_Tilit_Cycl_Press.time,t);
    dx.LeftTiltCylPressure = DownSampleData(d.Left_Tilt_Cyl_Press.val,d.Left_Tilt_Cyl_Press.time,t);
    dx.InletPressure = DownSampleData(d.InletTiltPressSensor.val,d.InletTiltPressSensor.time,t);
    
   %% create if loop for certain drive files
    
   if(~isempty(regexp(data.MetaData.DriveFileName,'E-W','match')))
        
       for n = 1:length(dx.t)      
     
       %Error
       
       if dx.ErrorR2(n) < dx.ErrorL2(n);
            Error(n) = dx.ErrorL2(n);
            
       else Error(n) = dx.ErrorR2(n);
       end

       %Cylinder Pressure
       
       if dx.RightTiltCylPressure(n) <= dx.LeftTiltCylPressure(n);
            CylinderPressure(n) = dx.LeftCylinderPressure(n);
            
       else CylinderPressure(n) = dx.RightTiltCylPressure(n);
       end
       
       
       %Tilt Command Up
       
       if dx.RightTiltUp(n) <= dx.LeftTiltUp(n);
            TiltUp(n) = dx.LeftTiltUp(n);
            
       else TiltUp(n) = dx.RightTiltUp(n);
       end
        
       
       %Tilt Command Down
       
       if dx.RightTiltDown(n) <= dx.LeftTiltDown(n);
            TiltDown(n) = dx.LeftTiltDown(n);
            
       else TiltDown(n) = dx.RightTiltDown(n);
       end
       
       
       %%Stop/Start (0) or Run (1)
       
       if ew_mask(n) == 0
           %start/stop
          Condition(n) = 0;
          
       else Condition(n) = 1 %Run;
       end
       
       %Inlet Pressure
       
       
       %L2 or R2
       R2 = (dx.R2 - (dx.R2Offsets));
       L2 = (dx.L2 - (dx.L2Offsets));
       
       %String Pots on Tires
      
       end   

       
%% Features
MaxError = (Error');
ErrorR2 = dx.ErrorR2
ErrorL2 = dx.ErrorL2
CenterFrameRollRate_RotPot = (dx.CenterFrameRollRate);
%ChasisRoll = abs(dx.ChasisRoll);
CenterFrameRoll_LVDT = (dx.CenterFrameRoll);
%ChassisRollRate = abs(dx.ChasisRollRate);
DriveFile = cell(1,length(dx.t));
DriveFile(:) = {data.MetaData.DriveFileName};
DriveFile = DriveFile';
Speed = dx.Speed;      
CylinderPressure= CylinderPressure';
TiltDown = TiltDown';
LeftTiltDown = dx.LeftTiltDown;
RightTiltDown = dx.RightTiltDown;
TiltUp = TiltUp';
LeftTiltUp = dx.LeftTiltUp;
RightTiltUp = dx.RightTiltUp;
Condition = Condition';
InletPress = dx.InletPressure;
L2;
R2;
ChassisPitchRate = dx.ChassisPitchRate;
ChassisRollRate = dx.ChassisRollRate;
ChassisYawRate = dx.ChassisYawRate ;
ChassisRollAngle = dx.ChassisRollAngle;
RightFront  =dx.RightFront;
LeftFront = dx.LeftFront;
RightBack = dx.RightBack;
LeftBack =  dx.LeftBack;
%Pitch
%Yaw
%Roll
   %% Create Data Table for every singular run
   
   %% Create Figure of Boom 
   figure;
   yyaxis right
   plot(dx.t,dx.CenterFrameRoll);
   yyaxis left
   plot(dx.t,dx.CenterFrameRollRate);
   hold on
   title(sprintf('Name: %s',fname{i}))
   hold on
   legend('LVDT','Deere Sensor')
   hold off
   
%% Create Data Table for Export

if i == 1
    DataTableField_1 = table(MaxError,CenterFrameRollRate_RotPot,CenterFrameRoll_LVDT, CylinderPressure,Speed,TiltUp, TiltDown, Condition,InletPress,ChassisPitchRate,ChassisRollAngle,ChassisRollRate,ChassisYawRate,RightFront,LeftFront,RightBack,LeftBack);    
    writetable(DataTableField_1,'DataTableField_1EW.csv');
    DataTableField_SpeedMask_1 = table(MaxError(ew_mask),CenterFrameRollRate_RotPot(ew_mask),CenterFrameRoll_LVDT(ew_mask), CylinderPressure(ew_mask),TiltUp(ew_mask), TiltDown(ew_mask),InletPress(ew_mask),ChassisPitchRate(ew_mask),ChassisRollAngle(ew_mask),ChassisRollRate(ew_mask),ChassisYawRate(ew_mask),RightFront(ew_mask),LeftFront(ew_mask),RightBack(ew_mask),LeftBack(ew_mask));    
    writetable(DataTableField_SpeedMask_1,'DataTableField_1EW_SpeedMask.csv');
elseif i == 2
    DataTableField_2 = table(MaxError,CenterFrameRollRate_RotPot,CenterFrameRoll_LVDT, CylinderPressure,Speed,TiltUp, TiltDown, Condition,InletPress,ChassisPitchRate,ChassisRollAngle,ChassisRollRate,ChassisYawRate,RightFront,LeftFront,RightBack,LeftBack);   
    writetable(DataTableField_2,'DataTableField_2EW.csv');
elseif i == 3
    DataTableField_3 = table(MaxError,CenterFrameRollRate_RotPot,CenterFrameRoll_LVDT, CylinderPressure,Speed,TiltUp, TiltDown, Condition,InletPress,ChassisPitchRate,ChassisRollAngle,ChassisRollRate,ChassisYawRate,RightFront,LeftFront,RightBack,LeftBack);    
    writetable(DataTableField_3,'DataTableField_3EW.csv');
elseif i == 4
    DataTableField_4 = table(MaxError,CenterFrameRollRate_RotPot,CenterFrameRoll_LVDT, CylinderPressure,Speed,TiltUp, TiltDown, Condition,InletPress,ChassisPitchRate,ChassisRollAngle,ChassisRollRate,ChassisYawRate,RightFront,LeftFront,RightBack,LeftBack);
    writetable(DataTableField_4,'DataTableField_4EW.csv');
end

   end
   clear Error
   clear CylinderPressure
   clear Condition
   clear TiltUp
   clear TiltDown
end


toc