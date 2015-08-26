library(difR)
      datamatrix=read.table("c:/users/ruiguo1/desktop/simulation_r/datamatrix.dat")
mantel_result=difMH(datamatrix,group= 50 ,focal.name=1,alpha= 0.30          ,purify=TRUE)
Iman_diff=mantel_result$DIFitems
if (Iman_diff=="No DIF item detected")
{Iman_diff=c()}
write(Iman_diff,file="Iman_diff.dat",ncolumns=1)
