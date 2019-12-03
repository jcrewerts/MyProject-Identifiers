function xfilt = UBSfilter(x)




for k = 2:length(x)
    
    if(x(k) < 65535)
        
    else
        x(k) = x(k-1);
    end
    
    
end

xfilt = x;

for k = 5:length(x)
    
    xfilt(k) = median(x(k-4:k));
end


for k = 2:length(x)
    
    if((xfilt(k)-xfilt(k-1)) > 1800)
        xfilt(k) = 400;
    end
    
    
    if(xfilt(k)-xfilt(k-1) > 110)
        xfilt(k) = xfilt(k-1) + 110;
    elseif(xfilt(k) - xfilt(k-1) < -110)
        xfilt(k) = xfilt(k-1) - 110;
    end
        
end