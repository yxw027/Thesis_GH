%% L Drabsch
clear
clc
close all
constants();
%% approximate location
GS_LLH = [-deg2rad(33);deg2rad(151);0]; % sydney
GS_ECEF = llhgc2ecef(GS_LLH);  % global


%% Location of receivers

% numRec = 5;
% Rec_dispersion = 10; % in meters, how far apart to have the receivers
% Rec_displacement = Rec_dispersion*rand([3,numRec-1]);
numRec = 4;
Rec_displacement = 100*[5,0,10,0;0,10,0,0;0,0,0,10];   % use NED coords
Rec_ecef_local = lg2ecef(Rec_displacement,GS_LLH);
allRec = GS_ECEF*ones(1,numRec)+Rec_ecef_local;
true_rel_alpha = Rec_displacement(:,2:end)-repmat(Rec_displacement(:,1),[1,3]);
%allRec = allRec';


%% Location of Satellites
el = deg2rad([30,20,25,28]);
az = [pi/2+0.01,0,pi,3*pi/2];
[x,y] = polar2plot(az,el);
polarfig = PolarPlot();
hold on
scatter(x,y)

allSat = sat_ned2ecef(el,az,GS_LLH); % global frame

timevec = 0;
plotyes = 1;
if plotyes ==1
    animation3Dearth;
    hold on
    scatter3(allSat(1,:),allSat(2,:),allSat(3,:))
end


%% Calculate range and add errors
Estruc.satmag = 10^-4;
Estruc.recmag = 10^-6;
Estruc.random = 10^-7;
range_error = rangesim(allRec,allSat,Estruc);

%% Find Relative positions
[Loc_lin,clockbias] = planarsolve(range_error,allSat,numRec, GS_ECEF);
Receivers_LG = ecef2lg(Loc_lin',GS_LLH) % NED cartesion row is rec col is xyz

%Loc_plane = Loc_lin(2:end,:)-ones(numRec-1,1)*Loc_lin(1,:);
%Receivers_LG = ecef2lg(Loc_plane',GS_LLH); % NED cartesion row is rec col is xyz

%% Evaluate
%error_alpha = Receivers_LG- true_rel_alpha;

