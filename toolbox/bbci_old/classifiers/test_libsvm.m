% test classification with SVM


%% Classification Data Generation: three shifted, noisy sine waves

% erste KLasse:
x1=0:0.1:10;
x2=sin(x1)+0.3*randn(1,length(x1))
x=[x1;x2];

%Zweite Klasse:
x1=0.05:0.1:10.05;
x2=sin(x1)+0.3*randn(1,length(x1))-.3

%Merge
x=[x [x1;x2]];

%Dritte Klasse:
x1=0.07:0.1:10.07;
x2=sin(x1)+0.3*randn(1,length(x1))-.6

%Merge
x=[x [x1;x2]];

%Labels
y= [ones(1,length(x1)) , zeros(1,length(x1)) , zeros(1,length(x1)) ; zeros(1,length(x1)), ones(1,length(x1)), zeros(1,length(x1)) ; zeros(1,length(x1)), zeros(1,length(x1)), ones(1,length(x1))];

%Schöne Mischung
idx= randperm(length(x));
x= x(:,idx);
y= y(:,idx);

close all
plot(x(1,y(1,:)==1),x(2,y(1,:)==1),'b.');
hold on
plot(x(1,y(2,:)==1),x(2,y(2,:)==1),'r.');
plot(x(1,y(3,:)==1),x(2,y(3,:)==1),'g.');

hold off




% %% Classification: two shifted, noisy sine waves
% 
% % erste KLasse:
% x1=0:0.1:10;
% x2=sin(x1)+0.3*randn(1,length(x1))
% x=[x1;x2];
% 
% %Zweite Klasse:
% x1=0.05:0.1:10.05;
% x2=sin(x1)+0.3*randn(1,length(x1))-0.5
% 
% %Merge
% x=[x [x1;x2]];
% plot(x(1,:),x(2,:),'.');
% 
% %Labels
% y= [ones(1,length(x1)) , zeros(1,length(x1)); zeros(1,length(x1)), ones(1,length(x1))];
% 
% %Schöne Mischung
% idx= randperm(length(x));
% x= x(:,idx);
% y= y(:,idx);
% 
% close all
% plot(x(1,y(1,:)==1),x(2,y(1,:)==1),'b.');
% hold on
% plot(x(1,y(2,:)==1),x(2,y(2,:)==1),'r.');
% hold off


%% Test classification
% C_search=[3:1:11];
% g_search=[-2.5:0.5:-0.5];
% 
% % C_search=[0:0.25:12];
% % g_search=[-3:0.25:1];
% 
% close all
% collect= zeros(length(C_search), length(g_search));
% tic
% for my_C=C_search
%     for my_g=g_search
%         C2=train_libsvm(x(:,1:100),y(:,1:100), 's',0, 't',2, 'c', 10^my_C, 'g', 10^my_g,'b', 0,'q',1);
%         [y_Out]= apply_libsvm(C2, x(:,101:200),'b',0);
%         my_diff=sqrt(sum(sum((y_Out - y(:,101:200)).^2))) / (size(y_Out,2)*size(y_Out,1));
%         collect(find(C_search==my_C),find(g_search==my_g),:)= my_diff;
%     end
% end
% toc
% 
% close all
% % Careful when plotting imagesc: x and y axes are interchanged, AND y axis is flipped ... why?
% imagesc(g_search,C_search,collect); set(gca,'YDir','normal'); set(gca,'XDir','normal'); 
% title('SVM Model Selection') ; ylabel('regularization param C (10^x)'); xlabel('kernel width gammma (10^x)') ; zlabel('mean abs error') ; colorbar
% figure(1)


% figure;
% [plot_C, plot_g] = meshgrid (C_search, g_search);
% surf(plot_C, plot_g, collect'); 
% title('SVM Model Selection') ; xlabel('log-regularization parameter C'); ylabel('log-kernel width gammma') ; zlabel('MSE')


%semilogx(collect(1,:), collect(2,:)) ; title('error') ; xlabel('kernel width gammma') ; ylabel('mean abs error')
%figure(1)
%figure(1) ; imagesc(y_ClassOut) ; figure(2) ; imagesc(y(:,181:200))




%% Regression Data Generation
% x=0:0.001:0.3;
% y=chirp(x)+0.2*randn(1,length(x))

x=0:0.1:30;
y=sin(x)+0.2*randn(1,length(x))

% Permute data points
idx= randperm(length(x));
x= x(:,idx); y= y(:,idx);
figure ; plot(x,y,'*')



%% Test regression

% Train and test with default hyperparameters
% for regularization parameter C, and largest kernel width (more linear!)
tic; C=train_libsvm(x(:,1:50),y(:,1:50), 's',3, 't',2, 'b', 0,'q',1); toc
[y_Out]= apply_libsvm(C,x(:,151:300) ,'b',0); % completely new test points

% Plot result
figure;
plot(x(:,151:300),y_Out,'*'); 
hold on ; grid on ; 
plot(x(:,151:300),y(:,151:300),'r*'); 
plot(x(:,1:50),y(:,1:50),'kx')
title('SVM regression result - default hyperparameters')
legend({'estimate for test points','true test points','training points'});

% % for sin
 C_search=[-2:0.2:4.5];
 g_search=[-2.5:0.1:0.5];

% for chirp
% C_search=[-2:0.25:6];
% g_search=[2.75:0.25:4.5];

% % dummy search

% C_search=[2:1:6];
% g_search=[-4:2:6];


% Parameter selection on first 50 data points, test with next 100 data
% points
collect= zeros(length(C_search), length(g_search));
tic
for my_C=C_search
    for my_g=g_search
        C=train_libsvm(x(:,1:50),y(:,1:50), 's',3, 't',2, 'c', 10^my_C, 'g', 10^my_g,'b', 0,'q',1);
        [y_Out]= apply_libsvm(C,x(:,51:150) ,'b',0);
        my_diff=sqrt(sum((y_Out - y(:,51:150)).^2)) / (size(y_Out,2)*size(y_Out,1));
        collect(find(C_search==my_C),find(g_search==my_g),:)= my_diff;
    end
end
toc

% Visualize error dependent on hyperparameter choice
figure;
% Careful when plotting imagesc: x and y axes are interchanged, AND y axis is flipped ... why?
H=imagesc(g_search,C_search,log(collect)); hold on; 
set(gca,'YDir','normal'); set(gca,'XDir','normal'); 
title('SVM Model Selection log MSE') ; ylabel('regularization param C (10^x)'); xlabel('kernel width gammma (10^x)') ; zlabel('mean abs error') ; colorbar

% Search best combination of hyperparameters
[C_minloc,g_minloc,minval]=find(collect==min(min(collect)));

% Train and test with best parameters, prefer smallest value
% for regularization parameter C, and largest kernel width (more linear!)
C=train_libsvm(x(:,1:50),y(:,1:50), 's',3, 't',2, 'c', 10^C_search(C_minloc(1)), 'g', 10^g_search(g_minloc(end)),'b', 0,'q',1);
[y_Out]= apply_libsvm(C,x(:,151:300) ,'b',0); % completely new test points

% Plot result
figure;
plot(x(:,151:300),y_Out,'*'); 
hold on ; grid on ; 
plot(x(:,151:300),y(:,151:300),'r*'); 
plot(x(:,1:50),y(:,1:50),'kx')
title('SVM regression result - hyperparameters optimized')
legend({'estimate for test points','true test points','training points'});

% ToDo: Optimization of hyperparameters within cross validation

