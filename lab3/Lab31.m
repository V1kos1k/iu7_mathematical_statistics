function Lab31()
%% аппроксимация неизвестной зависимости параболой
%Вариант 12
    close all;
    T = importdata('t.txt');
    Y = importdata('y.txt');
    
    One(1:length(T), 1) = 1;
    T2 = T.^2;
    F = horzcat(One, T, T2);

    Ft = transpose(F);
    theta = Ft * F \ Ft*Y;
    
    Yt = theta(1) + theta(2) * T + theta(3) * T2; 
    delta = sqrt(sum((Y - Yt).^2));
    deltaS = sprintf('\\Delta = %.5f\n', delta);
    
    figure(1);
    
    %переопределим Yt, чтобы не получать кусочную функцию на малых выборках
    T_G = min(T):0.01:max(T);
    T_G2 = T_G.^2;
    Yt = theta(1) + theta(2) * T_G + theta(3) * T_G2;
    
    plot(T, Y, '.r'); %экспериментальные данные
    hold on;
    
    plot(T_G, Yt, 'b'); %полученная аппроксимация
    %grid on;
    
    text(20,20, deltaS, 'Units', 'pixels');
    
    y_eq = sprintf('y = %.2f + %.2f*t + %.2f*t^2', theta(1), theta(2), theta(3));
    legend('Y experimental', y_eq);
   
%   кубическое
    One(1:length(T), 1) = 1;
    T2 = T.^2;
    T3 = T.^3;
    F = horzcat(One, T, T2, T3);

    Ft = transpose(F);
    theta = Ft * F \ Ft*Y;
    
    Yt = theta(1) + theta(2) * T + theta(3) * T2 + theta(4) * T3;
    delta = sqrt(sum((Y - Yt).^2));
    deltaS = sprintf('\\Delta_к_у_б = %.5f\n', delta);
    
    figure(1);
    
    %переопределим Yt, чтобы не получать кусочную функцию на малых выборках
    T_G0 = min(T):0.01:max(T);
    T_G2 = T_G0.^2;
    T_G3 = T_G0.^3;
    Yt = theta(1) + theta(2) * T_G0 + theta(3) * T_G2 + theta(4) * T_G3;
    
    plot(T_G0, Yt, 'm--'); %полученная аппроксимация
    grid on;
    
    text(260,20, deltaS, 'Units', 'pixels');
    
    y_eq1 = sprintf('y = %.2f + %.2f*t + %.2f*t^2 + %.2f*t^3',...
        theta(1), theta(2), theta(3), theta(4));
    
    legend('Y experimental', y_eq, y_eq1);

end