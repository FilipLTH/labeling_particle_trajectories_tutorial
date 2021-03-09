
function [traj] = generateTrajectoryODE(settings)

fsz = 16; %fontsize for plots
% interpMethod = 'linear'; %'linear' is fast, 'spline' is slow, 'bicubic' is slow (?)

% Fluid properties
rhof = settings.rhof;       %fluid density
Cf = settings.Cf;        %fluid speed of sound 
vis = settings.vis;      %fluid viscosity
Kappaf=1/rhof/Cf^2; %fluid compressibility

% Particle data
a = settings.a;         %particle radius
rhop = settings.rhop;        %particle density
Gamma=rhop/rhof;    %particle relative density
Kappap = settings.Kappap;    %particle compressibility
Beta=Kappap/Kappaf; %particle relative compressibility

% Resonator properties
W = settings.W;           %channel width
H = settings.H;           %channel height


% Acoustic field
f=Cf/2/W;           %frequency
ky=pi/W;            %wave vector along y
Eac = settings.Eac;             %acoustic energy density
v1=2*sqrt(Eac/rhof);    %acousitc particle velocity amplitude

% Calculate acoustic contrast factor
thbou=sqrt(2*vis/rhof/2/pi/f); %boundary layer thickness
f1=1-Beta;          %f1, to calculate acoustic contrast
f2=(2+3*thbou/a)*(Gamma-1)/(2*Gamma+1+9*thbou/2/a); %f2, to calculate acoustic contrast
Phi=f1/3+f2/2;    %acoustic contrast factor

%Gravity field
g = settings.g;              %gravitational constant

% Time settings
N = settings.N;              %number of timesteps
T = settings.T;             %end time of trajectory
traj.time = linspace(0,T,N);  %time vector where to evaluate
dt = traj.time(2) - traj.time(1); %needed to set time step max in ODE solver

Fg=-(rhop-rhof)*g*(4/3)*pi*a^3;       %Calculate net force of gravity

% Do the ODE
%These parameters are to be passed to the ODE
param.v1 = v1;
param.Cf = Cf;
param.ky = ky;
param.W = W;
param.H = H;
param.a = a;
param.Eac = Eac;
param.coeff = Phi;
param.vis = vis;
param.Fnet = Fg;
param.tOn = settings.tOn;
param.theta = settings.theta;

tspan = [0 T];
r0 = [settings.yStart, settings.zStart];

options = odeset('MaxStep',dt);

% [~,r] = ode15s(@(t,r) particleVelocityODE(t,r,param), tspan, r0, options);
[t,r] = ode45(@(t,r) particleVelocityODE(t,r,param), tspan, r0, options);


% Interplate to evaluate at the time points given in settings
traj.y = interp1(t,r(:,1),traj.time,'PCHIP');
traj.z = interp1(t,r(:,2),traj.time,'PCHIP');

% Plot the trajectories
if settings.display
    figure(4)
    hold on
%     plot(traj.y,traj.z,'.');
    scatter(traj.y,traj.z,[],traj.time,'.');
    xlim([-W/2 W/2]);
    ylim([-H/2-10e-6 H/2+10e-6]);
    set(gca,'DataAspectRatio',[1 1 1]);
    set(gca,'FontSize',fsz);
    set(gca,'LineWidth',1);
    xticks([-W/2 0 W/2]);
    xticklabels({'-W/2','0','W/2'});
    yticks([-H/2 0 H/2]);
    yticklabels({'-H/2','0','H/2'});
    xlabel('y')
    ylabel('z')
    title('Particle position map')
    
    figure(4)
end
end