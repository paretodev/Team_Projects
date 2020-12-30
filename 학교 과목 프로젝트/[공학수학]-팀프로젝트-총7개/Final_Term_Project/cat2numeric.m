function x = cat2numeric(A)

if size(A,2) ~= 15
    error("check data size")
end
%pre-processing the data
x =zeros(size(A, 1), 91);
%puts age
x(:, 1) = zscore(A.age);
%puts workClass
temp = grp2idx(A.workClass);
temp(isnan(temp)) = 1+size(categories(A.workClass),1);
for i = 1 : size(A,1)
    x(i, 1+temp(i)) = 1;
end
%puts education_num
x(:, 11) = zscore(A.education_num);
%puts marital_status
temp = grp2idx(A.marital_status);
temp(isnan(temp)) = 1+size(categories(A.marital_status),1);
for i = 1 : size(A,1)
    x(i, 11+temp(i)) = 1;
end
%puts occupation
temp = grp2idx(A.occupation);
temp(isnan(temp)) = 1+size(categories(A.occupation),1);
for i = 1 : size(A,1)
    x(i, 18+temp(i)) = 1;
end
%  puts relationship
temp = grp2idx(A.relationship);
temp(isnan(temp)) = 1+size(categories(A.relationship),1);
for i = 1 : size(A,1)
    x(i, 33+temp(i)) = 1;
end
% puts race
temp = grp2idx(A.race);
temp(isnan(temp)) = 1+size(categories(A.race),1);
for i = 1 : size(A,1)
    x(i, 39+temp(i)) = 1;
end
% puts sex
x(:, 45) = grp2idx(A.sex)-1;
% puts capital_gain
temp=A.capital_gain;
temp(temp~=0) = log10(temp(temp~=0));
x(:, 46) = zscore(temp);
% puts capital_loss
temp=A.capital_loss;
temp(temp~=0) = log10(temp(temp~=0));
x(:, 47) = zscore(temp);
% puts hours_per_week
x(:, 48) = zscore(A.hours_per_week);
% puts native_country
temp = grp2idx(A.native_country);
temp(isnan(temp)) = 1+size(categories(A.native_country),1);
for i = 1 : size(A,1)
    x(i, 48+temp(i)) = 1;
end
%puts salary ( 1 if higher than 50000, 0 if lower)
x(:, 91) = (A.salary=='>50K');

end

%column# | category  | ignore the numbers | attributes
%---------------------------------------------------
%1   age  (17~90)                           AGE       Z-SCORED !!

%2  federal-gov,                           WORKCLASS
%3  local-gov
%4  never-worked,
%5  private
%6  self-emp-inc
%7  self-emp-not-inc
%8  state-gov
%9  without-pay
%10 NumMissing (undefined)

%11 education_num (1 ~16 )              EDUCATION NUM  Z-SCORED !!

%12 Divorced                             MARITAL STATUS
%13         Married-AF-spouse                
%14            Married-civ-spouse         
%15            Married-spouse-absent        
%16            Never-married             
%17            Separated                
%18            Widowed
%19         Adm-clerical                        OCCUPATION
%             Armed-Forces                9    
%             Craft-repair             4099    
%             Exec-managerial          4066    
%             Farming-fishing           994    
%             Handlers-cleaners        1370    
%             Machine-op-inspct        2002    
%             Other-service            3295    
%             Priv-house-serv           149    
%             Prof-specialty           4140    
%             Protective-serv           649    
%             Sales                    3650    
%             Tech-support              928    
%             Transport-moving         1597    
%33           NumMissing               1843  

%34           Husband               13193            RELATIONSHIP
%             Not-in-family          8305     
%             Other-relative          981     
%             Own-child              5068     
%             Unmarried              3446     
% 39          Wife                   1568 

% 40          Amer-Indian-Eskimo            311       RACE
%             Asian-Pac-Islander     1039 
%             Black                  3124 
%             Other                   271 
%             White                 27816 

% 45          Sex(0 IF female, 1 if male)           SEX

% 46          capital_gain (0~99999)            log10 the non-zeros then Z-SCORED !!

% 47          capital_loss  (0~4356)            log10 the non-zeros then Z-SCORED !!

% 48          hours per week (1~99)             Z-SCORED !!

% 49          Cambodia                   19         NATIVE COUNTRY
%50           Canada                               121      
%             China                                 75      
%             Columbia                              59      
%             Cuba                                  95      
%             Dominican-Republic                    70      
%             Ecuador                               28      
%             El-Salvador                          106      
%             England                               90      
%             France                                29      
%             Germany                              137      
%             Greece                                29      
%             Guatemala                             64      
%             Haiti                                 44      
%             Holand-Netherlands                     1      
%             Honduras                              13      
%             Hong                                  20      
%             Hungary                               13      
%             India                                100      
%             Iran                                  43      
%             Ireland                               24      
%             Italy                                 73      
%             Jamaica                               81      
%             Japan                                 62      
%             Laos                                  18      
%             Mexico                               643      
%             Nicaragua                             34      
%             Outlying-US(Guam-USVI-etc)            14      
%             Peru                                  31      
%             Philippines                          198      
%             Poland                                60      
%             Portugal                              37      
%             Puerto-Rico                          114      
%             Scotland                              12      
%             South                                 80      
%             Taiwan                                51      
%             Thailand                              18      
%             Trinadad&Tobago                       19      
%             United-States                      29170      
%             Vietnam                               67      
%             Yugoslavia                            16      
%  90         NumMissing  (undefined)              583      

%  91         SALARY(0 if <=50K, 1 if >50k)                    SALARY