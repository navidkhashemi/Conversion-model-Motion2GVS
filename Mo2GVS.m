%%%% %%%%%%%%%%%%% Kinetic motion to GVS conversion model
%
% Author: Navid Khosravi-Hashemi
% Purpose: to generate the equivalent GVS current profile to the chair
% rotation stimulation
% Version 1.00
% Date: 16-01-2019
% This code can be downloaded from <https://github.com/......
%
%%%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [EVS]=Mo2GVS(a,d,t)

%-------------------------------------------------------------------------
% EVS=Mo2GVS(a,d,t)
% This program computes the GVS current profile needed to generate the
% similar perception to the physical rotational velocity profile defined by 
% the user. It is assumed that the person is sitting with their head peached 
% 72.7 degrees downward(this angle is computed using the orientation of human
% semicircular canals measured by three-dimensional multiplanar CT reconstruction,
% Della Santina et al. 2005). The physical velocity profile is consisted of three
% parts: an ascending ramp starting at 0 degrees/sec, a constant velocity 
% segment, and a descending ramp with an acceleration same as the ascending 
% ramp in absolute value. The user defines the ramp acceleration (a), ramp 
% duration (d), and the constant velocity duration (t) as the function inputs. 
% The function will plot the motion velocity profile (top panel) and the computed 
% equivalent GVS current profile (bottom panel). The function returns a 
% discretized GVS current profile over time with 0.1-second time steps.
% 
% Usage Examples,
% 
% 1- To plot the motion and the equivalent GVS current profiles.
% When,
% the ramp acceleration is: 10 m/sec^2 >>> a=10 
% the ramp duration is: 1 second >>>> d=1
% the constant velocity duration is: 60 sec >>> t=60
% Mo2GVS(10,1,60);
% 
% 2- To plot the motion and the equivalent GVS current profiles as well as
% storing the discretized GVS current profile: 
% When,
% the ramp acceleration is: 10 m/sec^2 >>> a=10 
% the ramp duration is: 1 second >>>> d=1
% the constant velocity duration is: 60 sec >>> t=60
% EVS=Mo2GVS(10,1,60);
%----------------------------------------
% Copyright 2019 Navid Khosravi-Hashemi
%----------------------------------------
%---------------------------------------------------------------------------

dt = 0.1;   % time step of the model
MO=ramp(a,d,t);
GVS=MOtoGVS1(MO);
fig = figure;
set(fig,'Color','w','Units','Normalized','Position',[0.1 0.1 0.6 0.5]);
% plot the motion profile
subplot(2,1,1);
plot(0:dt:(length(MO)-1)*dt,MO,'g'); 
box off;
ylabel('motion velocity (degrees/s)');
xlabel('time(s)');
% plot the equivalent current profile
subplot(2,1,2);
plot(0:dt:(length(GVS)-1)*dt,GVS,'b'); 
box off;
ylabel('GVS current(mA)');
xlabel('time(s)');
dlmwrite('v10c.txt',GVS);
EVS=GVS;
end
function [MO]=ramp(a,d,t)
dt = 0.1;   % Time step of the model
MO=[linspace(0,a*d,d/dt+1) (a*d)*ones(1,t/dt) linspace(a*d,0,d/dt+1) zeros(1,30/dt)];
end

function [GVS]=MOtoGVS1(MO)
dt = 0.1;   % Time step of the model
Tc = 4;     % Cupula time constant (sec)
% using canal transfer function to find the afferent activity
time=(length(MO)-1)*dt;    % Total time of stimulation
t=0:dt:time;               % Time signal for stimulation
Hc=tf([Tc,0],[Tc,1]);       % Canal transfer function: St George,..,Fitzpatrick 2011, Fig3
C_full=(lsim(Hc,MO,t))';

% multiplying the inversed transfer functions to compute the equivalent GVS
% current profile

Hr=tf([98 20972 479024],[1 2625 121166]); % regular channels transfer function
Hir=tf([418 61864 682176],[1 2757 49302]); % irregular channels transfer function
Hri=inv(Hr);
Hiri=inv(Hir);
GVS=0.25*(3*(lsim(Hri,C_full,t))'+(lsim(Hiri,C_full,t))'); % about three-quarters
% of primary afferents are regular firing (Fitzpatrick and Day 2004,Baird et al. 1998, Goldberg JM 2000) 
end