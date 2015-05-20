function [res,LPCcoeff] = GetLPCresidual(wave,L,shift,order,gci,type,t0)

% %%%
%  
% Use: [res] = GetLPCresidual(wave,L,shift,order,gci,type,t0)
% 
% 
% L=window length (samples) (typ.25ms)
% shift=window shift (samples) (typ.5ms)
% order= LPC order
% gci=gci position (samples)
% type=vector of voicing decisions (=0 if Unvoiced, =1 if Voiced)
% t0=vector of period values (in samples)
% 
% Written by Thomas Drugman, TCTS Lab.
%
% Note that this code is taken from the GLOAT toolkit:
% http://tcts.fpms.ac.be/~drugman/Toolbox/
% 
% %%%

%% My Bit!!
% use: L = 25/1000*fs % 25 ms frame length
%     shift = 5/1000*fs % 5 ms shift
%     order = 24
wave=wave(:);
if nargin<5
    doPS=0;
else
    doPS=1;
end


if doPS==0
    start=1;
    stop=start+L;    
    res=zeros(1,length(wave));
    LPCcoeff=zeros(order+1,round(length(wave)/shift));
    n=1;
    while stop<length(wave)

        segment=wave(start:stop);
%         segment=segment.*hanning(length(segment));
		seg_len = length(segment);
        segment_hanning = 0.5*(1 -cos(2*pi*(1:seg_len)' /(seg_len +1))); % Hanning window
		segment = segment.*segment_hanning; 
        
        [A,e]=lpc(segment,order);
        LPCcoeff(:,n)=A(:);
        
        inv=filter(A,1,segment);
        
        inv=inv*sqrt(sum(segment.^2)/sum(inv.^2));

        res(start:stop)=res(start:stop)+inv';

        start=start+shift;
        stop=stop+shift;
        n=n+1;
    end

    res=res/max(abs(res));

else
    
    Ltot=length(wave);
    [begin,ending,frametype] = CompleteFramingWithType(gci,16000,Ltot,shift,L,type,t0);
    
    res=zeros(1,length(wave));
    for k=1:length(begin)
       
        start=begin(k);
        stop=ending(k);
        
        segment=wave(start:stop);
%         segment=segment.*hanning(length(segment));
		seg_len = length(segment);
        segment_hanning = 0.5*(1 -cos(2*pi*(1:seg_len)' /(seg_len +1))); % Hanning window
		segment = segment.*segment_hanning; 

        [A,e]=lpc(segment,order);

        inv=filter(A,1,segment);

        res(start:stop)=res(start:stop)+inv';
    end
        
    res=res/max(abs(res));
    
end
