function dtwcompare(s, s_e, sr)
    figure(1)
    [p, q, D] = dtw(s, s_e, sr);

    hold on; plot(q,p,'r'); hold off
    disp('спектральный анализ');
    disp(D(end,end));
    %disp(max(p)+max(q));
    figure(2)
    imagesc(D)
   hold on; plot(q,p,'r'); hold off
    colormap gray;
     disp('кепстральный анализ');
     figure(3)
    [p, q, D] = dtw2(s, s_e, sr);
    hold on; plot(q,p,'r'); hold off
    figure(4)
    imagesc(D)
    hold on; plot(q,p,'r'); hold off
    colormap gray;
    % [Dist, D2, k, w] = dtw1(s(1:8:end), s_e1(1:8:end));
    disp(D(end,end));
end