#load data required for n-mixture models
load("JAE-data.gzip")

library(rjags)

## format data
jd.cawa.pb <- list(y=cawa.count.3D2, #counts at each point
                   wind=wind3D2,# wind during surveys
                   noise=noise3D2, # noise during surveys
                   date=date3D.pbs2,# date of count
                   time=time3D2.mat, # time of day
                   climate=climate.var.new, # principle component of PRISM data
                   treatment=treat.mat, # treatment variable,
                   nSites=nrow(treat.mat), # 71 sites
                   nIntervals=c(4,4,4,4), # survey periods
                   T=length(cawa.count.3D2[1,1,]),
                   plotArea=pi) #years
str(jd.cawa.pb)


## initial values
ji.cawa.pb <- function() list(N=matrix(10,
                                       jd.cawa.pb$nSites,
                                       jd.cawa.pb$T),
                              beta0=rnorm(1), beta1=rnorm(1))
ji.cawa.pb()
str(ji.cawa.pb())

## parameters of interest
jp.cawa.clim.trt.D <- c("beta0", "beta1",
                        "alpha0", "alpha1", "alpha2", "alpha3","alpha4",
                        "lambda0", "lambda1", "lambda2", "lambda3",
                        "deviance", "Ntotal")

hist(exp(rnorm(10000, 0, sqrt(1/25))))


lamfn <- function() {
  lam0 <- rnorm(1, 0, sqrt(1/25))
  lam1 <- rnorm(1, 0, sqrt(1/10))
  x <- seq(-3, 3, length=20)
  exp(lam0 + lam1*x)
}

prior.lam <- replicate(n=1000, lamfn())

matplot(prior.lam, type="l", col=gray(0.5))
lines(rowMeans(prior.lam), col="blue", lwd=3)

rowMeans(prior.lam)


## Compiles the model 
load.module("dic")
jm.cawa.clim.trt.D <- jags.model(file="Abundance_EN_clim-trt-D.jag", #jags file
                                 data=jd.cawa.pb,#data
                                 inits=ji.cawa.pb, #initial values
                                 n.chains=3) #3 chains

## Draw posterior samples
jc.cawa.clim.trt.D <- coda.samples(jm.cawa.clim.trt.D,
                                   jp.cawa.clim.trt.D, n.iter=500)#iterations kept small for example, increase for full runs

jc.cawa.clim.trt.D.thin <- window(jc.cawa.clim.trt.D, thin=20)

summary(jc.cawa.clim.trt.D.thin)


## WAIC

## WAIC focused on p(y|N)p(N|theta)
ld.yN.cawa.clim.trt.D <- coda.samples(jm.cawa.clim.trt.D, "ld.yN.site.year.visit",
                                      n.iter=500)#iterations kept small for example, increase for full runs

ld.yN.cawa.clim.trt.D.thin <- window(ld.yN.cawa.clim.trt.D, thin=2)

(waic.yN.clim.trt.D <- waic(ld.yN.cawa.clim.trt.D.thin)) #WAIC

## WAIC focused on p(y|N)
ld.y.cawa.clim.trt.D <- coda.samples(jm.cawa.clim.trt.D, "ld.y.site.year.visit",
                                     n.iter=500) #iterations kept small for example, increase for full runs

ld.y.cawa.clim.trt.D.thin <- window(ld.y.cawa.clim.trt.D, thin=2)

(waic.y.clim.trt.D <- waic(ld.y.cawa.clim.trt.D.thin))



