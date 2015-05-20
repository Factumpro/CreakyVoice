function result = hann1ng(n)

result = 0.5*(1 - cos(2*pi*(1:n)'/(n+1)));