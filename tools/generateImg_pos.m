function generateImg_pos(filename)

% Resonator properties
W = 375e-6;
H = 150e-6;
max_speed = 2e-6;
settings_exp.W = W;           %channel width
settings_exp.H = H;           %channel height

% get sim settings
settings_sim = sim_settings_get_pos();
while ~strcmp(settings_sim.label,'pos')
    settings_sim = sim_settings_get_pos();
end

%Simulate a trajectory
trajSim = generateTrajectoryODE(settings_sim);


%% Paint image

% Image initialize
img_width = 224;
img_height = 224;
image = zeros(img_width,img_height,3);

% Paint image
for i = 2:length(trajSim.y) 
    y = coordinate_to_pixel_y(trajSim.y(i),settings_exp.W,img_width);
    z = coordinate_to_pixel_z(trajSim.z(i),settings_exp.H,img_height);
    dy = trajSim.y(i)-trajSim.y(i-1);
    dz = trajSim.z(i)-trajSim.z(i-1);
    speed = sqrt(dy^2+dz^2);

    image(z,y,3) = 1 - speed/max_speed; % Blue
    image(z,y,1) = speed/max_speed /2; % Red
    image(z,y,2) = speed/max_speed /2; % Green

end

% Paint start point
y = coordinate_to_pixel_y(trajSim.y(1),settings_exp.W,img_width);
z = coordinate_to_pixel_z(trajSim.z(1),settings_exp.H,img_height);
image = insertShape(image,'FilledCircle',[y z 2],'SmoothEdges',false,'Color','green');

% Paint end point
y = coordinate_to_pixel_y(trajSim.y(length(trajSim.y)),settings_exp.W,img_width);
z = coordinate_to_pixel_z(trajSim.z(length(trajSim.y)),settings_exp.H,img_height);
image = insertShape(image,'FilledCircle',[y z 2],'SmoothEdges',false,'Color','red');


%% Save
if settings_sim.imshow
    imshow(image)
    title(sprintf('%s', settings_sim.label), 'FontSize', 14);
else % Do not write images if imshow is true

    if strcmp(settings_sim.label,'pos')
        imwrite(image,sprintf('temp/pos/%d.png',filename))
    elseif strcmp(settings_sim.label,'neg')
        imwrite(image,sprintf('temp/neg/%d.png',filename))
    elseif strcmp(settings_sim.label,'zero')
        imwrite(image,sprintf('temp/zero/%d.png',filename))
    end    

end

end