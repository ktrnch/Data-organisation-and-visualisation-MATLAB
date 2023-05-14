load('data.mat')
st=[1 -1 1 -1 1 1 -1 -1 1 1];
start_sig=strfind(data, st); %finding places where start of signal met
nr_of_sequences=length(start_sig); %determining amount of seqences
num_t=zeros([1 nr_of_sequences]);
for i=1:(nr_of_sequences-1)
    t_beginning=start_sig(i)+18; %based on length of start and date determining place, where t values begin
    t_end=start_sig(i+1)-1;% and end
    num_t(i)=t_end-t_beginning; %finding amount of t values on each day
end
max_nr_of_temperature_values=max(num_t); % max num of t values from all the sequences
data_struc = zeros(nr_of_sequences, 10+8+max_nr_of_temperature_values);% creatig data structure
day={};
bin_day={};
for i=1:nr_of_sequences %looping thrrough data to create a structured array
    data_struc(i,1:10)=st; %adding start of signal
    for j=start_sig(i) %looping through places, where every signal starts
        data_struc(i,11:18)=data(j+10:j+17); %to add days
        if num_t(i)==(max_nr_of_temperature_values) % and temperatures
            data_struc(i,19:10+8+max_nr_of_temperature_values)=data(j+18:j+17+num_t(i)); % without zeros if amount of t is max 
        else % and with zeros if not 
            nan=zeros([1 (max_nr_of_temperature_values-num_t(i))]); % amount of zeros needed to add
            t=data(j+18:j+17+num_t(i)); % amount of t
            t=[t nan];
            data_struc(i,19:10+8+max_nr_of_temperature_values)=t;
        end
    end
    bin=strcat(string(data_struc(i,11:18))); % turning day signal into text and concatenating it
    bin_day=[bin_day join(bin)];% creating an array of concanated binary days
    data_struc(i,11:18)=bin2dec(bin_day(i));% converting bin days to dec and replacing them in matrix
end
data_sort=sortrows(data_struc,11); %structuring data based on day
data_clean=strings([153,2]);%creating empty arrays 
d_temps=zeros;% 
data_clean(1, 1:2)=["Day0"; "mean temperature"];% adding first row
for i=2:153 % looping througth temeratures and days to fill the rest 
    day=string(data_sort(i-1,11));
    d_temps=(data_sort(i-1,19:num_t(i-1)));%creating array of t per day
    ave_temp(i)=mean(d_temps);% finding average of it
    data_clean(i,1:2)=["Day"+day;ave_temp(i)];
end
stem(1:152,ave_temp(2:153))% visualising results
