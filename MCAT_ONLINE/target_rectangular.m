function [r1,r2,r3,r4] = target_rectangular(targets1,targets2,targets3,targets4,target_p) 
%%
epsilon = .005;

r1 = zeros(size(targets1,1),1);
r2 = zeros(size(targets2,1),1);
r3 = zeros(size(targets3,1),1);
r4 = zeros(size(targets4,1),1);
%%
for item = 1:length(r1)
    %%
    target1 = targets1(item,:);
    target2 = targets2(item,:);
    target3 = targets3(item,:);
    target4 = targets4(item,:);
    
    %
    for target_index = 1:4
        %%
        if target_index == 1
            target = target1;
        elseif target_index == 2
            target = target2;
        elseif target_index == 3
            target = target3;   
        else            
            target = target4;
        end
        
        r = .01;
        while r < 2
            mvnval  = mvncdf(target-r,target+r,[0,0],[1,0;0,1]);
            if mvnval >= target_p
                if target_index == 1
                    r1(item) = r;
                elseif target_index == 2              
                    r2(item) = r;
                elseif target_index == 3
                    r3(item) = r;           
                else
                    r4(item) = r;
                end
                break;
            end
            r = r + epsilon;
        end
    end
end

        
                
                
                
                