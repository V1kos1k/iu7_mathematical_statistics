function lab1()
    % считать данные из файла
    X = csvread('data.csv');
    
    X = sort(X);
    n = length(X);
    
    fprintf("\n%g\n", n);
    
    % минимальное значение выборки
    minX = min(X);
    fprintf("Min = %4.2f\n", minX);
    
    % максимальное значение выборки
    maxX = max(X);
    fprintf("Max = %4.2f\n", maxX);
    
    % размах выборки
    R = maxX - minX;
    fprintf("R = %4.2f\n", R);
    
    
    % вычисление оценок мат ожидания и дисперсии
    mu = sum(X)/n;
    fprintf("mu = %4.2f\n", mu);
    
    % несмещенная оценка дисперсии
    di = sum((X-mu).^2)/(n-1);
    
    %S2di = disp(X);
    fprintf("sigma^2 = %4.2f\n", di);
    
    % группировка значений выборки m = [log_2 n] + 2 интервала
    m = floor(log2(n)) + 2;
    fprintf("m = %g\n", m);
    
    n = length(X);
    m = floor(log2(n)) + 2;
    delta = R / m;
    group = zeros(m, 2);
    %указываем границы интервалов
    for j = 1:m
        group(j,1) = X(1)+delta*j;
    end
    %раскидываем элементы по интервалам
    j = 1;
    i = 1;
    border = X(1)+delta;
    while i < n
        if X(i) >= border && border < X(n) && j < 8
            border = border + delta;
            j = j + 1;
            continue; %чтобы корректно обрабатывать ситуациии, когда в
        %интервал не попадает ни один элемент выборки
        end
        group(j, 2) = group(j, 2) + 1;
        i = i + 1;
    end
    group(m, 2) = group(m, 2) + 1; %последний (n-й) элемент всегда будет
    %принадлежать последнему (m-му) интервалy
    
    for i = 1:m
        if i == 1
            fprintf('[%.6f', minX);
        else
            fprintf('[%.6f', group(i-1, 1));
        end
        fprintf(' - %.6f', group(i, 1));
        if i == m
            fprintf(']');
        else
            fprintf(')');
        end
        fprintf(': %d elements\n', group(i, 2));
    end

    % функция распределения (син)
    % эмпирическая функция распределения
    Xlen = zeros(1, n+2);
    Xlen(1) = X(1) - 1;
    for j = 1:n
        Xlen(j+1) = X(j);
    end
    Xlen(n+2) = X(n) + 1;
    
    nn = length(Xlen);
    Mmin = min(Xlen);
    Mmax = max(Xlen);
    step = (Mmax - Mmin) / nn;
    xs = Mmin:step:Mmax;
    
    %получаем функцию распределения для нормальной случайной величины
    F = normcdf(xs, mu, sqrt(di));
    
    %строим эмпирическую функцию распределения
    E = zeros(nn, 1);
    for i = 1:nn
        count = 0;
        for j = 1:n
            if X(j) <= Xlen(i)
                count = count+1;
            end
        end
        E(i) = count / n;
    end
    %строим графики
    hold on;
    plot(xs, F, "--"), grid;
    stairs(Xlen, E), grid;
    
    figure();
    
    % гистограмма и функция плотности
    gist = zeros(m,2);
    gist(1,1) = (X(1) + group(1, 1))./ 2;
    for i = 2:m
        gist(i,1) = (group(i-1,1) + group(i, 1)) ./ 2;
    end
    %модифицируем Y для гистограммы - количество_попаданий / (n*delta)
    for i = 1:m
        y = group(i,2);
        y = y / (n*delta);
        gist(i,2) = y;
    end
    %вычисляем значения функции плотности распределения для всех Х из выборки
    F = normpdf(X, mu, sqrt(di));
    %отображаем значения
    bar(gist(:,1), gist(:,2), 1);
    hold on;
    
    plot(X, F,'r'), grid;
end
