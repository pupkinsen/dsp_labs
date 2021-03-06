classdef (ConstructOnLoad) Ats < handle
    properties
        Registr = [0 0 0 0 0 0];
        In_buf;
        Last_transmit=0;
        Last_transmit_level=1;
        Out_buf;
        Current_num=0;
        Errors=0;
        Busy=0; %0-������� ��������, 1-������� �����
        Side; %0-��������, 1-�����
        Status; %0-���������,1-�������� ������,2-�������� ��������
        
    end
    methods (Static)
        function num = num_send(num_v) %������������ ������� ��� ��������
            %conditions
            Ns=400;
            Np=2000;
            No=8000;
            f0=700;
            f1=900;
            f2=1100;
            f4=1300;
            f7=1500;
            f11=1700;
            fd=8000;
            Xm1=1;
            
            %initialize
            T=1/f1;
            Td=1/fd;
            fi1=0*pi;
            ts=(0:Td:(Td*Ns)-Td);
            tp=(0:Td:(Td*Np)-Td);
            to=(0:Td:(Td*No)-Td);
            %generating signals

            x0=Xm1*sin((2*pi*f0).*ts+fi1);
            x1=Xm1*sin((2*pi*f1).*ts+fi1);
            x2=Xm1*sin((2*pi*f2).*ts+fi1);
            x4=Xm1*sin((2*pi*f4).*ts+fi1);
            x7=Xm1*sin((2*pi*f7).*ts+fi1);
            x11=Xm1*sin((2*pi*f11).*ts+fi1);

            dp=0.*tp;
            ds=0.*ts;
            do=0.*to;

            %frequency combinations
            k=zeros(15,Ns);
            k(1,:)=x0+x1; %����� 1/������ �������� 1 �����
            k(2,:)=x0+x2; %����� 2/������ �������� ��������� �����
            k(3,:)=x1+x2; %����� 3/������ �������� ���������� �����
            k(4,:)=x0+x4; %����� 4/���������� ������� ��������
            k(5,:)=x1+x4; %����� 5/���������� ������� �����
            k(6,:)=x2+x4; %����� 6/������ ���������� �����, �������� � �������
            k(7,:)=x0+x7; %����� 7/������� ����������
            k(8,:)=x1+x7; %����� 8/������ �������� ���� ����� �������� �����
            k(9,:)=x2+x7; %����� 9/������ ���������� ���� �������� �����
            k(10,:)=x4+x7; %����� 0/������ ���� ������� � ���������� �������� �����
            k(11,:)=x0+x11; %������/������ ��������� �������������� ������
            k(12,:)=x1+x11; %������������� ������ �������� ���. ����. 4,5,8,9,10/������
            k(13,:)=x2+x11; %������ �������� �������� ������/������
            k(14,:)=x4+x11; %���������. ������������� ���������/������
            k(15,:)=x7+x11; %�������������. ������������� ����������/������
            num=squeeze(k(num_v,:));
        end
        
        function num_v = num_read(num) %������������� �������� �����
            %conditions

            f0=700;
            f1=900;
            f2=1100;
            f4=1300;
            f7=1500;
            f11=1700;
            fd=8000;

            num_v=16;


            %%%%%%% ��������� ����� � ������ ����� %%%%%%%
            r=rand(1);
            if r>0.9
                num=num+wgn(1,length(num),50);
            end
            
            %incomig message processing

            freq_ind0=round(f0/fd*length(num))+1;
            freq_ind1=round(f1/fd*length(num))+1;
            freq_ind2=round(f2/fd*length(num))+1;
            freq_ind4=round(f4/fd*length(num))+1;
            freq_ind7=round(f7/fd*length(num))+1;
            freq_ind11=round(f11/fd*length(num))+1;

            num_spect0=abs(goertzel(num,freq_ind0));
            num_spect1=abs(goertzel(num,freq_ind1));
            num_spect2=abs(goertzel(num,freq_ind2));
            num_spect4=abs(goertzel(num,freq_ind4));
            num_spect7=abs(goertzel(num,freq_ind7));
            num_spect11=abs(goertzel(num,freq_ind11));

            threshold=100;
            if ((num_spect0>threshold)&&(num_spect1>threshold)&&(num_spect2<threshold)&&(num_spect4<threshold)&&(num_spect7<threshold)&&(num_spect11<threshold))
                num_v=1;
            end
            if ((num_spect0>threshold)&&(num_spect1<threshold)&&(num_spect2>threshold)&&(num_spect4<threshold)&&(num_spect7<threshold)&&(num_spect11<threshold))
                num_v=2;
            end
            if ((num_spect0<threshold)&&(num_spect1>threshold)&&(num_spect2>threshold)&&(num_spect4<threshold)&&(num_spect7<threshold)&&(num_spect11<threshold))
                num_v=3;
            end
            if ((num_spect0>threshold)&&(num_spect1<threshold)&&(num_spect2<threshold)&&(num_spect4>threshold)&&(num_spect7<threshold)&&(num_spect11<threshold))
                num_v=4;
            end
            if ((num_spect0<threshold)&&(num_spect1>threshold)&&(num_spect2<threshold)&&(num_spect4>threshold)&&(num_spect7<threshold)&&(num_spect11<threshold))
                num_v=5;
            end
            if ((num_spect0<threshold)&&(num_spect1<threshold)&&(num_spect2>threshold)&&(num_spect4>threshold)&&(num_spect7<threshold)&&(num_spect11<threshold))
                num_v=6;
            end
            if ((num_spect0>threshold)&&(num_spect1<threshold)&&(num_spect2<threshold)&&(num_spect4<threshold)&&(num_spect7>threshold)&&(num_spect11<threshold))
                num_v=7;
            end
            if ((num_spect0<threshold)&&(num_spect1>threshold)&&(num_spect2<threshold)&&(num_spect4<threshold)&&(num_spect7>threshold)&&(num_spect11<threshold))
                num_v=8;
            end
            if ((num_spect0<threshold)&&(num_spect1<threshold)&&(num_spect2>threshold)&&(num_spect4<threshold)&&(num_spect7>threshold)&&(num_spect11<threshold))
                num_v=9;
            end
            if ((num_spect0<threshold)&&(num_spect1<threshold)&&(num_spect2<threshold)&&(num_spect4>threshold)&&(num_spect7>threshold)&&(num_spect11<threshold))
                num_v=10;
            end
            if ((num_spect0>threshold)&&(num_spect1<threshold)&&(num_spect2<threshold)&&(num_spect4<threshold)&&(num_spect7<threshold)&&(num_spect11>threshold))
                num_v=11;
            end
            if ((num_spect0<threshold)&&(num_spect1>threshold)&&(num_spect2<threshold)&&(num_spect4<threshold)&&(num_spect7<threshold)&&(num_spect11>threshold))
                num_v=12;
            end
            if ((num_spect0<threshold)&&(num_spect1<threshold)&&(num_spect2>threshold)&&(num_spect4<threshold)&&(num_spect7<threshold)&&(num_spect11>threshold))
                num_v=13;
            end
            if ((num_spect0<threshold)&&(num_spect1<threshold)&&(num_spect2<threshold)&&(num_spect4>threshold)&&(num_spect7<threshold)&&(num_spect11>threshold))
                num_v=14;
            end
            if ((num_spect0<threshold)&&(num_spect1<threshold)&&(num_spect2<threshold)&&(num_spect4<threshold)&&(num_spect7>threshold)&&(num_spect11>threshold))
                num_v=15;
            end
        end

    end
  
    methods
        
        function obj = send_cur(obj)% ��������� ������� ����� ��������
            %obj.Out_buf=obj.num_send(obj.Registr(obj.Current_num));
            obj.send(obj.Registr(obj.Current_num));
            obj.Current_num=obj.Current_num+1;
        end
        
        function obj = send(obj,val)% ��������� ����� �� ���������
             %if ((obj.Side==0)&&(val~=6))||((obj.Side==1)&&(val~=13))
             %    obj.Last_transmit=[obj.Last_transmit val];
             %       obj.Last_transmit_level=obj.Last_transmit_level+1;
                 %obj.Last_transmit(obj.Last_transit_level)=val;
             %else
             %    if ((obj.Side==0)&&(obj.Last_transmit(obj.Last_transit_level)~=6))||((obj.Side==1)&&(obj.Last_transmit(obj.Last_transit_level)~=13))
             %       obj.Last_transmit=[obj.Last_transmit val];
             %       obj.Last_transmit_level=obj.Last_transmit_level+1;
             %    end
             %end
                %if (obj.Side==0)&&(val==6)||(obj.Side==1)&&(val==13)
                
                %debug stuff
             if  obj.Last_transmit(obj.Last_transmit_level)~=val  
                obj.Last_transmit=[obj.Last_transmit val];
                obj.Last_transmit_level=obj.Last_transmit_level+1;
             end
                %disp(['side=' num2str(obj.Side) ' sending: ' num2str(val)]);
                    

                
            obj.Out_buf=obj.num_send(val);
        end
        
        function obj = init_transmission(obj) %������ ������ ��������
            obj.Current_num=1;
            obj.Status=1;
            obj.Side=1;
            obj.send(1);
        end
        
        function obj = repeat(obj) %��������� ����� (???)
            
           obj.Errors=obj.Errors+1;
           obj.send(obj.Last_transmit(obj.Last_transmit_level));
           if ((obj.Side==1)&&(obj.Last_transmit(obj.Last_transmit_level)==6))||((obj.Side==0)&&(obj.Last_transmit(obj.Last_transmit_level)==13))
               obj.Last_transmit(obj.Last_transmit_level)=[];
               obj.Last_transmit_level=obj.Last_transmit_level-1;
           end
            
            
        end
        
        function obj=incoming(obj) %��������� ��������� �������
            num=obj.num_read(obj.In_buf);
            if obj.Side==0 %��� ���������� �������
                              
                
                if num==1 %������ ������ ������ ����� 
                    obj.Current_num=1;
                    obj.Status=1;
                    obj.send_cur();
                end
                
                if num==2 %������ ��������� �����              
                    obj.send_cur();
                end
                if num==3 %������ ���������� ����� 
                    obj.Current_num=obj.Current_num-1;
                    obj.send_cur();
                end
                if num==4 %������� �������� 
                    obj.send(12);
                    obj.Busy=0;
                    obj.Current_num=0;
                    obj.Status=0;
                end
                if num==5 %������� ����� 
                    obj.send(12);
                    obj.Busy=1;
                    obj.Current_num=0;
                    obj.Status=0;
                end
                if num==6 %������ ��������, ��������� 
                    obj.repeat;
                end
                if num==16 %������ ������, ������ ���������� 
                    obj.send(13);
                end
            end
            if obj.Side==1 %��� ����������� �������
                
                
                
                if obj.Status==1 %� �������� ��������
                    if (num==1)||(num==2)||(num==3)||(num==4)||(num==5)||(num==6)||(num==7)||(num==8)||(num==9)||(num==10)
                        if num==10 %����� 0
                            obj.Registr(obj.Current_num)=0;
                        else
                            obj.Registr(obj.Current_num)=num;
                        end
                        obj.Current_num=obj.Current_num+1;
                        if obj.Current_num>length(obj.Registr)%���������� �������� (???)
                            obj.Status=2;
                            if obj.Busy==0
                                obj.send(4); %������� ��������
                            else
                                obj.send(5); %������� �����
                            end

                        else
                            obj.send(2);
                        end
                    end
                    

                end
                if obj.Status==2 %����� ���������� ��������
                    if num==12 %������������� ����������
                    
                    end
                        
                end
                if num==13 %������ ��������, ��������� 
                    obj.repeat;
                end
                if num==16 %������ ������, ������ ���������� 
                    obj.send(6);
                end
            end
        end
    end
end