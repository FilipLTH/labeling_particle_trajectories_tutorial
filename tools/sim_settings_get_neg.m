function settings_sim = sim_settings_get_neg()
%% CONST -------------------------------------------------------
settings_sim.display = false;
settings_sim.W = 375e-6;           %channel width
settings_sim.H = 150e-6;           %channel height
settings_sim.g = 9.8;              %gravitational constant
settings_sim.imshow = false;
% End image properties ---------------------------------------
settings_sim.img_width = 224;
settings_sim.img_height = 224;
%% ----------------------------------------------------------

%% Default values

% Fluid properties
settings_sim.rhof = 1000;      %fluid density
settings_sim.Cf = 1500;        %fluid speed of sound 
settings_sim.vis = 1.1705e-3;      %fluid viscosity

% Particle data
settings_sim.a = 5e-6/2;         %particle radius
settings_sim.rhop = 1050;        %particle density
%settings_sim.Kappap = 1.6534e-10;    %particle compressibility
settings_sim.Kappap = 4.66*1e-10;

% Acoustic field
settings_sim.Eac = 20;             %acoustic energy density

% Time
settings_sim.N = 100;            %number of timesteps
settings_sim.T = 10;            %end time of trajectory
settings_sim.tOn = 0;           %time when the soundfield is activated 

% Standing wave location
settings_sim.theta = 0;         % parameter to finetune the location of the standing wave



%% Randomize
settings_sim.Kappap = (8e-10 - 4.5e-10) * rand + 4.5e-10;

% Randomize starting point
settings_sim.yStart = rand*(settings_sim.W-2*settings_sim.a)-settings_sim.W/2;
settings_sim.zStart = rand*(settings_sim.H-2*settings_sim.a)-settings_sim.H/2;

%% Labelize:

% Akustisk kontrast
settings_sim.Kappaf = 1/(settings_sim.Cf^2 * settings_sim.rhof);
settings_sim.Phi = (1 - settings_sim.Kappap/settings_sim.Kappaf) / 3 + ...
    (settings_sim.rhop/settings_sim.rhof - 1)/(2 * settings_sim.rhop/settings_sim.rhof + 1);

if settings_sim.Phi > 0.05
    settings_sim.label = 'pos';
elseif settings_sim.Phi < -0.05
    settings_sim.label = 'neg';
elseif abs(settings_sim.Phi) < 0.005
    settings_sim.label = 'zero';
else
    settings_sim.label = 'skip';
end


end