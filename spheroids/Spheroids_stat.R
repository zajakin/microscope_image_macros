
 project<-"Spheroids formation in the presence of chemical compounds"
 dir("data","Results.txt",recursive = TRUE,full.names = TRUE)

 plate1<-read.delim("data/wbf344250513_120717_Spheroids_with_W3W4W5Qinhib_Nadja_13_05_2025/results/Results.txt",row.names = 1)
 plate2<-read.delim("data/wbf344250513_123338_Spheroids_with_W3W4W5Qinhib_controls_Nadja_13_05_2025/results/Results.txt",row.names = 1)
 # plate3<-read.delim("data/wbf344250513_123338_Spheroids_with_W3W4W5Qinhib_controls_Nadja_13_05_2025_250513_123338_Plate 1/results/Results.txt",row.names = 1)
 # cbind(plate2[,c("Area","Circ.")],plate3[,c("Area","Circ.")])
 
 table(duplicated(sub("_.*","",plate1$Label)))
 table(duplicated(sub("_.*","",plate2$Label)))
 # table(duplicated(sub("_.*","",plate3$Label)))
 
 rownames(plate1)<-sub("_.*","",plate1$Label)
 rownames(plate2)<-sub("_.*","",plate2$Label)
 # rownames(plate3)<-sub("_.*","",plate3$Label)
 
 plate1[paste0(c("B","C","D"),rep(1:4,each=3)),"Compound"]<-"W3"
 plate1[paste0(c("E","F","G"),rep(1:4,each=3)),"Compound"]<-"W3+I"
 plate1[paste0(c("B","C","D"),rep(5:8,each=3)),"Compound"]<-"W4"
 plate1[paste0(c("E","F","G"),rep(5:8,each=3)),"Compound"]<-"W4+I"
 plate1[paste0(c("B","C","D"),rep(9:12,each=3)),"Compound"]<-"W5"
 plate1[paste0(c("E","F","G"),rep(9:12,each=3)),"Compound"]<-"W5+I"
 
 plate2[paste0(c("B","C","D"),rep(1:4,each=3)),"Compound"]<-"Q4"
 plate2[paste0(c("E","F","G"),rep(1:4,each=3)),"Compound"]<-"Q+I"
 plate2[paste0(c("B","C","D"),rep(5:8,each=3)),"Compound"]<-"I"
 plate2[paste0(c("E","F","G"),rep(5:8,each=3)),"Compound"]<-"KDMSO"
 plate2[paste0(c("B","C","D"),rep(9:12,each=3)),"Compound"]<-"K"
 plate2[paste0(c("E","F","G"),rep(9:12,each=3)),"Compound"]<-"KDMSO"
 
 dotplot<-function(plate=plate,test="Mann-Whitney test",ylab=""){
   all_pv<-data.frame()
   # gplots::heatmap.2(plate,scale="row",col=gplots::greenred(75),na.rm=TRUE, key=TRUE, density.info="none", trace="none",mar=c(10,10),cexRow = 1)
   # tmp<-data.frame(Compound=as.factor(cat[1]),y=as.numeric(data[i,colData[colData$Gr==cat[1],"Name"]]),check.names = FALSE)
   # for(j in cat[-1]) tmp<-rbind(tmp, data.frame(Compound=as.factor(j),y=as.numeric(data[i,colData[colData$Gr==j,"Name"]]),check.names = FALSE) )
   gr<-as.character(unique(plate$Compound))
   x<-combn(gr,2)[,1]
   my_pv<-data.frame(t(combn(gr,2,function(x) c(x,
                                                signif(mean(plate[plate[,"Compound"]==x[1],2]),2),
                                                signif(mean(plate[plate[,"Compound"]==x[2],2]),2),
                                                signif(log(signif(mean(plate[plate[,"Compound"]==x[1],2]),2),2)-log(signif(mean(plate[plate[,"Compound"]==x[2],2]),2),2),2),
                                                if(test=="t-test"){ signif(t.test(plate[plate[,"Compound"]==x[1],2],plate[plate[,"Compound"]==x[2],2],p.adjust.method="none")$p.value,2)
                                                } else signif(wilcox.test(plate[plate[,"Compound"]==x[1],2],plate[plate[,"Compound"]==x[2],2],p.adjust.method="none")$p.value,2)
   ), simplify = T)))
   
   colnames(my_pv)<-c("group1","group2","mean1","mean2","logFC","p.value")
   my_pv<-my_pv[!is.nan(my_pv[,"p.value"]) & my_pv[,"p.value"]!="NaN",]
   # all_pv<-rbind(all_pv,cbind(Name=rep(i,nrow(my_pv)),my_pv))
   my_pv<-my_pv[order(as.numeric(my_pv$p.value)),]
   all_pv<-my_pv<-cbind(my_pv,FDR=signif(p.adjust(as.numeric(my_pv$p.value),method = "fdr"),2))
   
   my_pv_FDR<-my_pv[as.numeric(my_pv[,"FDR"])<=0.05,]
   print(ggpubr::ggboxplot(plate, x = "Compound", y = "Area", fill="Compound", add = "jitter") + # , palette = "jco"
           ggplot2::theme_bw(base_size = 18) + ggplot2::theme(legend.position="none",title = ggplot2::element_text(size = 14)) + ggplot2::labs(x="Compounds",y=ylab, title = project) + 
           ggpubr::stat_pvalue_manual( my_pv_FDR,label = paste0(test,", adj. p.value = {FDR}"), tip.length = 0.01, y.position = seq(round(max(plate$Area))*1.01,
                           round(max(plate$Area))*1.2, length.out=nrow(my_pv_FDR) ), bracket.shorten = 0.05))

   my_pv<-my_pv[as.numeric(my_pv[,"p.value"])<=0.05,]
   print(ggpubr::ggboxplot(plate, x = "Compound", y = "Area", fill="Compound", add = "jitter") + # , palette = "jco"
           ggplot2::theme_bw(base_size = 18) + ggplot2::theme(legend.position="none",title = ggplot2::element_text(size = 14)) + ggplot2::labs(x="Compounds",y=ylab, title = project) + 
           ggpubr::stat_pvalue_manual( my_pv,label = paste0(test,", p.value = {p.value}"), tip.length = 0.01, y.position = seq(round(max(plate$Area))*1.01,
                           round(max(plate$Area))*1.2, length.out=nrow(my_pv) ), bracket.shorten = 0.05))
   return(all_pv)
 }
 
 write2xlsx<-function(data=c(),wb,sheet="Sheet1", ...){
   if(nchar(sheet)>31) sheet<-substr(sheet,1,31)
   openxlsx::addWorksheet(wb = wb, sheetName = sheet, gridLines = TRUE)
   openxlsx::freezePane(wb, sheet, firstActiveRow = 3, firstCol = TRUE)
   openxlsx::setColWidths(wb,sheet,cols=1:4,widths = "auto")
   openxlsx::writeData(wb, sheet = sheet, data, ...)
   return(sheet)
 }
 
 
 plate<-rbind(plate1,plate2)[,c("Compound","Area")]
 plate$Area<-as.numeric(plate$Area)
 plate$Compound<- factor(plate$Compound,levels = c("W3","W3+I","W4","W4+I","W5","W5+I","Q4","Q+I","I","KDMSO","K"))

 wbT<-openxlsx::createWorkbook()
 ylab="Spheroids area, px^2"
 pdf(paste0("data/",project,".pdf"), width = 8, height = 8)
 plateS<-plate[!(grepl("I",plate$Compound) | plate$Compound=="K"),]
 write2xlsx(dotplot(plate=plateS,test="t-test",ylab=ylab),wb = wbT,sheet = "t-test")
 write2xlsx(dotplot(plate=plateS,test="Mann-Whitney test",ylab=ylab),wb = wbT,sheet = "Mann-Whitney test")
 
 print(ggpubr::ggviolin(plate, x = "Compound", y = "Area", fill="Compound", add = "jitter") + # , palette = "jco"
         ggplot2::theme_bw(base_size = 18) + ggplot2::theme(legend.position="none",title = ggplot2::element_text(size = 14)) + ggplot2::labs(x="Compounds",y=ylab, title = project) )
 print(ggpubr::ggboxplot(plate, x = "Compound", y = "Area", fill="Compound", add = "jitter") + # , palette = "jco"
         ggplot2::theme_bw(base_size = 18) + ggplot2::theme(legend.position="none",title = ggplot2::element_text(size = 14)) + ggplot2::labs(x="Compounds",y=ylab, title = project) )
 write2xlsx(dotplot(plate=plate,test="t-test",ylab=ylab),wb = wbT,sheet = "All t-test")
 write2xlsx(dotplot(plate=plate,test="Mann-Whitney test",ylab=ylab),wb = wbT,sheet = "All Mann-Whitney test")
 
 
 openxlsx::saveWorkbook(wbT,paste0("data/",project,"_",format(Sys.time(), "%Y-%m-%d"),".xlsx"),overwrite = TRUE)
 dev.off()
 
 
 
 
 
 