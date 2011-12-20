clc
clear
%init
dp=squeeze(zeros(1,2000));
do=squeeze(zeros(1,4000));


ats_a=Ats();
ats_b=Ats();
ats_a.Registr=[2 7 4 2 5 1]; %номер для передачи
ats_b.Busy=0; %вызываемый абонент будет свободен
ats_a.Side=0;
ats_b.Side=1;
ats_b.init_transmission();
ats_a.Status=1;
ats_a.In_buf=ats_b.Out_buf;

sig=ats_b.Out_buf;

ats_a.incoming();
while ats_a.Status~=0

    ats_b.In_buf=ats_a.Out_buf();
    sig=[sig dp ats_a.Out_buf];
    ats_b.incoming();
    
    ats_a.In_buf=ats_b.Out_buf;
    sig=[sig do ats_b.Out_buf];
    ats_a.incoming();
end
sig=[sig dp ats_a.Out_buf];
if ats_a.Registr==ats_b.Registr
    disp('Передача завершена успешно!');
    if ats_a.Busy==1
        disp('Вызываемый абонент занят');
    else
        disp('Вызываемый абонент свободен');
    end
    disp(['атс А, ошибок приема:' num2str(ats_b.Errors)]);
    disp(['атс Б, ошибок приема:' num2str(ats_a.Errors)]);
    
else
    disp('Ошибка передачи номера');
end

 figure(2)
 plot(0:(1/8000):(length(sig)/8000)-(1/8000),sig);
 title('сигналы в линии');
 xlabel('t (c)');
 ylabel('A');
% вывод звукового файла
 wavwrite(sig,'sound.wav');