function xfilt = GeneralFilter(x)

%filter

xfilt=zeros(size(x));
xfilt(1)=0;

for n=2:length(x);

    xfilt(n)=[(xfilt(n-1)*4+(x(n)-x(n-1))*50)]/5;

end
    
end