function distance = dynamictimewarp(template, testsignal)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Classical Dynamic time warping algorithm as described in 
%   Sakoe, Chiba: Dynamic Programming Algorithm Optimization for Spoken
%   Word Recognition
%
%  (c) Tim J?rgens, Medizinische Physik, Feb.2006
%
%  usage: distance = dynamictimewarp(template, testsignal)
%
%   calculates distance with DTW 
%   adapted to time-frequency matrices like output of PEMO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 2,
    error('Not enough input arguments.');
end

if nargin > 2,
    error('Too many arguments.')
end

% OPTIONS
ShowWaitBar = 0;
DerivativeDTW = 0;
FindWayBack = 0;
Verbatim = 0;
Weighting = 0;
Make_Kerf_on_distancematrix = 0;

% Indicate progress ("waitbar")
if ShowWaitBar,
    h = waitbar(0, 'Time Warping...');
    waitbar(0,h);
end

% DerivativeDTW as in Keogh, Pazzanini, but with "diff"-command
if DerivativeDTW;
    template = template';
    testsignal = testsignal';
    difftemplate = diff(template)';
    difftestsignal = diff(testsignal)';
    template = difftemplate;
    testsignal = difftestsignal;
    template(:,end+1) = template(:,end);
    testsignal(:,end+1) = testsignal(:,end);
end

% Weightening function - corresponds to the fact that speech / hearing of
% speech happens with a certain weighting function (to be calculated from
% the german language speech material) that is loaded here
if Weighting,
    
    %frequency weighting
    load 'd:\tim\matlab\wichtung_test.mat';
    for i = 1:size(template,2)
        template(:,i) = template(:,i).*wichtung';
    end
    for i = 1:size(testsignal,2)
        testsignal(:,i) = testsignal(:,i).*wichtung';
    end
    
    %time weighting (emphasize middle phoneme)
    load 'd:\tim\matlab\wichtung_zeit_raw.mat';
    wichtung_zeit = abs(resample(wichtung_zeit_raw,size(template,2),length(wichtung_zeit_raw)));
    for i = 1:size(template,1)
        template(i,:) = template(i,:).*wichtung_zeit;
    end
    wichtung_zeit = abs(resample(wichtung_zeit_raw,size(testsignal,2),length(wichtung_zeit_raw)));
    for i = 1:size(testsignal,1)
        testsignal(i,:) = testsignal(i,:).*wichtung_zeit;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Distancematrix-Calculation. 
% The entry (i,j) contains the mean quadratic distance 
% between the two samples template(:,i) and 
% testsignal(:,j)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
distancematrix = zeros(length(template(1,:)),length(testsignal(1,:))); %preallocation due to speed

for i = 1:length(template(1,:))
    for j = 1:length(testsignal(1,:))
        distancematrix(i,j) = sqrt(sum((template(:,i)-testsignal(:,j)).^2));
        if ShowWaitBar,
            waitbar(i/length(template)/3,h);                  % refresh display of progress
        end 
    end
end

%plot distancematrix
if Verbatim,
   figure;
    imagesc([0:1/100:(size(distancematrix,1)-1)/100],[0:1/100:(size(distancematrix,2)-1)/100],distancematrix');
    axis xy;
    axis equal;
    axis tight;
    set(gca,'FontSize',16);
    xlabel('Time of Template (s)');
    ylabel('Time of Testsignal (s)');
    title('Distance Matrix');
    colorbar;     
end

if Make_Kerf_on_distancematrix,
    alpha = 1.5;
    kerf_matrix = make_kerf(alpha,length(template(1,:)),length(testsignal(1,:)));
    distancematrix = distancematrix.*kerf_matrix;
end
%plot distancematrix
% if Verbatim,
%    figure;
%     imagesc([0:1/100:(size(distancematrix,1)-1)/100],[0:1/100:(size(distancematrix,2)-1)/100],distancematrix');
%     axis xy;
%     axis equal;
%     axis tight;
%     set(gca,'FontSize',16);
%     xlabel('Time of Template (s)');
%     ylabel('Time of Testsignal (s)');
%     title('Distance Matrix');
%     colorbar;     
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find optimal path in the distancematrix due to the following constraints:
% i) boundary conditions: the path starts in the lower left and ends in the
%    upper right corner
% ii) continuity of the path (only direct or diagonal neighbour hopping)
% iii) monotony (the following point of the path has matrixindices >= the actual point)
% iv) the cost function is minimized
%
% therefore dynamic programming:
% calculating cumulative distance gamma (distance in the actual cell plus 
% minimum of distance in the allowed neighbourcells)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r = length(distancematrix(1,:))+length(distancematrix(:,1));%ceil((length(distancematrix(1,:))+length(distancematrix(:,1)))/4); % adjustment width of allowed corridor for warppath
i = 1;
j = 1;

%g = ones(length(template),length(testsignal)).*max(max(distancematrix))*length(distancematrix);  %initialize g to ensure that
% upper left and lower right corner limit warppath

g(1,1) = 2*distancematrix(1,1);    %initial condition

while (i <= size(template,2) || j <= size(testsignal,2))
    i = i+1;
    if (i > j+r)
        j = j+1;
        if (j > size(testsignal,2))
            distance = g(size(template,2), size(testsignal,2))/(size(template,2)+size(testsignal,2));
            break;
        else
            i = j-r;
        end
    elseif (i <= 0)
        i = 0;
    elseif (i > size(template,2))
        i = j+r;            % begrenzt die berechnung von zeilen von g
    elseif (j == 1)
        g(i,j) = g(i-1,j)+distancematrix(i,j);
    elseif (i == 1)
        g(i,j) = g(i,j-1)+distancematrix(i,j);
       
    else
        g(i,j) = min([g(i,j-1) + distancematrix(i,j), g(i-1,j-1) + 2*distancematrix(i,j), g(i-1,j) + distancematrix(i,j)]);
    end
end

%plot Cumulative Distance Matrix
if Verbatim,
    figure;
    imagesc([0:1/100:(size(g,1)-1)/100],[0:1/100:(size(g,2)-1)/100],g');
    axis xy;
    axis equal;
    axis tight;
    set(gca,'FontSize',16);
    xlabel('Time of Template (s)');
    ylabel('Time of Testsignal (s)');
    title('Cumulative Distance Matrix');
    colorbar;     
end

%%%%%%%%%%%%%%%%%% Finding Warppath back %%%%%%%%%%%%%%%%%%%%%%%%%%%
if FindWayBack,
    warppath.template = zeros(1,(size(template,2))+size(testsignal,2));   %you don't know how long the warppath is
    warppath.test = zeros(1,(size(template,2))+size(testsignal,2));
    warppath.template(end) = size(template,2);
    warppath.test(end) = size(testsignal,2);
    i = length(warppath.template);
    
    
    %%%%%%%%% test:testsignal-direction: rows, templ:template-direction: columns
    while((warppath.template(i) > 1) && (warppath.test(i) > 1))
        [tmp, index] = min([g(warppath.template(i)-1,warppath.test(i)-1),g(warppath.template(i),warppath.test(i)-1),g(warppath.template(i)-1,warppath.test(i))]);
        if (index == 1)
            warppath.template(i-1) = warppath.template(i)-1;
            warppath.test(i-1) = warppath.test(i)-1;
            i = i-1;
        elseif (index == 2)
            warppath.template(i-1) = warppath.template(i);
            warppath.test(i-1) = warppath.test(i)-1;
            i = i-1;
        elseif (index == 3)
            warppath.template(i-1) = warppath.template(i)-1;
            warppath.test(i-1) = warppath.test(i);
            i = i-1;
        else
            error('Found no way back');
        end
    end
    [tmp,initmpl] = find(warppath.template);
    [tmp,initest] = find(warppath.test);
    if Verbatim
        fighandle = figure;
        plot(warppath.template(initmpl(1):end), warppath.test(initest(1):end));
        set(gca,'FontSize',16);
        set(findobj(gcf,'Type','line'),'LineWidth',2,'Color','k');
        xlabel('Column Index of Distancematrix');
        ylabel('Row Index of Distancematrix');
        title('Warp Path');
        axis equal
        axis tight;
    end
end