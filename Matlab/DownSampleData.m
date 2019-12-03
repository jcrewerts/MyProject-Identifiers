function [y,t] = DownSampleData(x,t_in,t_DS)


%x = val
%t_in = time step entering the function
%t_DS = time step after downsample

% Downsample data to specified time step


% t = [floor(t_in(1)):t_step:floor(t_in(end)./t_step)*t_step]';
t = t_DS;
t_step = 1;

t_in = t_in./t_step;

y = zeros(length(t),1);
for k = 1:length(t)
    
    if(k < length(t))
        a = t_in >= t(k) ...
            & t_in <= t(k+1);
    else
        a = t_in > t(k);
    end
    
    if(sum(a) > 0)
        temp = x(a);
        
        y(k) = temp(1);%mean(x(a));%
    else
        if(k > 1)
            y(k) = y(k-1);
        else
            y(k) = 0;
        end
    end
end


