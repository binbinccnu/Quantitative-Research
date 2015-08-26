function zone = zone_divide(theta)

if theta(1) >= 0 
    if theta(2) >= 0
        zone = 1;
    else
        zone = 4;
    end
else
    if theta(2) >= 0
        zone = 2;
    else
        zone = 3;
    end
end