NS = 5;

%sample = randn(NS,1);
fsample = normpdf(sample,0,1);

eval = linspace(-3,3,200);

pdf = normpdf(eval,0,1);

[KDE,sigma_kde] = kde_simple(sample',eval);

figure(50)
clf
subplot(1,2,1)
plot(sample,sample*0,'kx','MarkerSize',30)

hold on

plot(eval,KDE,'-r','LineWidth',5)
plot(eval,pdf,'--k','LineWidth',5)

for s = sample'
    plot(eval,1/NS*normpdf(eval',s,sigma_kde),'--r','LineWidth',3)
end

xlim([-3,3])
ylim([-0.3,0.4])
legend('Samples','Kernel Density Estimate','Probability Density Function','Single Kernel','Location','South')

subplot(1,2,2)

plot(sample,sample*0,'kx','MarkerSize',30)

hold on

R_eval = sqrt(sqdistance(eval,sample'));
R_int = sqrt(sqdistance(sample'));

eps = fminbnd(@(ep) max(pdf' - rbf(R_eval,ep)/rbf(R_int,ep)*fsample),1e-2,1e1,optimset('Display','iter'));
c = rbf(R_int,eps)\fsample;

plot(eval,rbf(R_eval,eps)/rbf(R_int,eps)*fsample,'-b','LineWidth',5)
plot(eval,pdf,'--k','LineWidth',5)

for k = 1:NS
    plot(eval,c(k)/sum(c)*normpdf(eval',sample(k),eps),'--b','LineWidth',3)
end

xlim([-3,3])
ylim([-0.3,0.4])
legend('Samples','Radial Basis Function Estimate','Probability Density Function','Single Radial Basis Function','Location','South')
