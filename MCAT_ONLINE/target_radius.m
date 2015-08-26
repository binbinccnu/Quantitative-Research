function [r1,r2,r3,r4] = target_radius(target1,target2,target3,target4,target_p) 

epsilon = .005;

for target_index = 1:4
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
        mvnval  = mvnlps( [0,0]', [1 0;0 1],target', eye(2), r, 1e-5 );
        if mvnval >= target_p
            if target_index == 1
                r1 = r;
            elseif target_index == 2
                r2 = r;
            elseif target_index == 3
                r3 = r;
            else
                r4 = r;       
            end
            break;
        end
        r = r + epsilon;
    end
    if r >= 2
        if target_index == 1
            r1 = 2;
        elseif target_index == 2
            r2 = r;
        elseif target_index == 3
            r3 = r;
        else
            r4 = r;
        end 
    end
end

        
                
                
                
                