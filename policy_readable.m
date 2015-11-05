% policy_readable

% state
sizS=[2 3 3 10];
ind_lengthS=prod(sizS);
indices=1:ind_lengthS;
[u l m e] = ind2sub(sizS, indices);

u_table={'屏幕关'; '屏幕开'};
l_table={'光强弱' '光强中' '光强强'};
m_table={'移动静' '移动慢' '移动快'};
e_table={'电量等级1 ' '电量等级2 ' '电量等级3 ' '电量等级4 ' '电量等级5 ' '电量等级6 ' '电量等级7 ' '电量等级8 ' '电量等级9 ' '电量等级10'};

%action
sizA=[3 5];
ind_lengthA=prod(sizA);
indices=1:ind_lengthA;
[a_display a_gps] = ind2sub(sizA, indices);

display_table={'亮度20% ' '亮度60% ' '亮度100%'};
gps_table={'GPS  1s' 'GPS  5s' 'GPS 10s' 'GPS 30s' 'GPS 60s'};

% write to the result.txt
fid = fopen('result2.txt','w');

for i=1:ind_lengthS
    fprintf(fid,'%d',i);
    fprintf(fid,'\t%s,%s,%s,%s',u_table{u(i)},l_table{l(i)},m_table{m(i)},e_table{e(i)});
    action=policy(i); 
    [disp gps]=ind2sub(sizA,action);
    fprintf(fid,'\t%s,%s\r\n',display_table{disp},gps_table{gps} );
end
fclose(fid);