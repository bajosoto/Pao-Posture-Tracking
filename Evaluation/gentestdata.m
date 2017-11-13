
samples = {};

for i=1:6
    csvwrite(['class',int2str(i)],floor(mvnrnd([i,i,i,i,i,i],eye(6),10)*1000));
    %disp(class)
end
fisherm