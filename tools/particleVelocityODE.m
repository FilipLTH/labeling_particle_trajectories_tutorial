function drdt = particleVelocityODE(t,r,param)

% r = [y, z]

v1 = param.v1;
Cf = param.Cf;
ky = param.ky;
W = param.W;
H = param.H;
a = param.a;
Eac = param.Eac;
Phi = param.coeff;
vis = param.vis;
Fg = param.Fnet;
tOn = param.tOn; %time when sound is turned on
theta = param.theta; %(shift of the pressure nodal position)

if t > tOn
    ustry = 3/16*v1^2/Cf*sin(2*ky*(r(1) + W/2 + theta))*(1-3*r(2)^2/(H/2)^2); %Acoustic streaming along y
    Frad = -2*ky*2*pi*a^3*Eac*Phi*sin(2*ky*r(1) + theta);   %Acoustic radiation
    vy = (Frad / (6 * pi * vis * a) + ustry);       %Total velocity along y
    
    v2z = 3/16 * v1^2 / Cf*ky*H*cos(2*ky*(r(1)+W/2 + theta))*(r(2)^3/(H/2)^3-r(2)/(H/2)); %Acoustic streaming along y
    vz = Fg/(6*pi*vis*a)+v2z; %Total velocity along z
else
    vy = 0; %before the sound is on, the particle cannot move in y
    vz = Fg/(6*pi*vis*a); % only gravity when sound is off
end

% check if inbetween walls or if moving towards center
if abs(r(1)) < W/2 - a || sign(vy) ~= sign(r(1))
    drdt(1) = vy;       %assign vy
else
    drdt(1) = 0;        %else do not move any further
end

% check if inside floor and ceiling or if moving towards mid height
if abs(r(2)) < H/2 - a || sign(vz) ~= sign(r(2))
    drdt(2) = vz;              %assign vz
else
    drdt(2) = 0;                %else do not move any further
end


drdt = drdt';


