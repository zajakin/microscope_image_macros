
 project<-"Spheroids formation in the presence of chemical compounds"
 dir("data","Results.txt",recursive = TRUE,full.names = TRUE)

 plate1<-read.delim("data/wbf344250513_120717_Spheroids_with_W3W4W5Qinhib_Nadja_13_05_2025/results/Results.txt",row.names = 1)
 plate2<-read.delim("data/wbf344250513_123338_Spheroids_with_W3W4W5Qinhib_controls_Nadja_13_05_2025/results/Results.txt",row.names = 1)
 # plate3<-read.delim("data/wbf344250513_123338_Spheroids_with_W3W4W5Qinhib_controls_Nadja_13_05_2025_250513_123338_Plate 1/results/Results.txt",row.names = 1)
 plate4<-read.delim("data/wbf344250924_104901_Spheroids_with_W3W4W5Qinhib_Nadja_24_09_2025/results_901/Results.txt",row.names = 1)
 # cbind(plate2[,c("Area","Circ.")],plate3[,c("Area","Circ.")])
 
 table(duplicated(sub("_.*","",plate1$Label)))
 table(duplicated(sub("_.*","",plate2$Label)))
 table(duplicated(sub("_.*","",plate4$Label)))
 
 rownames(plate1)<-sub("_.*","",plate1$Label)
 rownames(plate2)<-sub("_.*","",plate2$Label)
 rownames(plate4)<-sub("_.*","",plate4$Label)
 
 plate1[paste0(c("B","C","D"),rep(1:4,each=3)),"Groups"]<-"thioQ(OAc)5"
 plate1[paste0(c("E","F","G"),rep(1:4,each=3)),"Groups"]<-"thioQ(OAc)5+I"
 plate1[paste0(c("B","C","D"),rep(5:8,each=3)),"Groups"]<-"thioQ"
 plate1[paste0(c("E","F","G"),rep(5:8,each=3)),"Groups"]<-"thioQ+I"
 plate1[paste0(c("B","C","D"),rep(9:12,each=3)),"Groups"]<-"thioQ(OAc)4"
 plate1[paste0(c("E","F","G"),rep(9:12,each=3)),"Groups"]<-"thioQ(OAc)4+I"
 
 plate1[paste0(c("B","C","D","E","F","G"),rep(c(1,5,9),each=6)),"Set"]<-"8000"
 plate1[paste0(c("B","C","D","E","F","G"),rep(c(1,5,9)+1,each=6)),"Set"]<-"4000"
 plate1[paste0(c("B","C","D","E","F","G"),rep(c(1,5,9)+2,each=6)),"Set"]<-"2000"
 plate1[paste0(c("B","C","D","E","F","G"),rep(c(1,5,9)+3,each=6)),"Set"]<-"1000"
 
 plate2[paste0(c("B","C","D"),rep(1:4,each=3)),"Groups"]<-"Q"
 plate2[paste0(c("E","F","G"),rep(1:4,each=3)),"Groups"]<-"Q+I"
 plate2[paste0(c("B","C","D"),rep(5:8,each=3)),"Groups"]<-"I"
 plate2[paste0(c("E","F","G"),rep(5:8,each=3)),"Groups"]<-"CTR"
 plate2[paste0(c("B","C","D"),rep(9:12,each=3)),"Groups"]<-"K"
 plate2[paste0(c("E","F","G"),rep(9:12,each=3)),"Groups"]<-"CTR"
 
 plate2[paste0(c("B","C","D","E","F","G"),rep(c(1,5,9),each=6)),"Set"]<-"8000"
 plate2[paste0(c("B","C","D","E","F","G"),rep(c(1,5,9)+1,each=6)),"Set"]<-"4000"
 plate2[paste0(c("B","C","D","E","F","G"),rep(c(1,5,9)+2,each=6)),"Set"]<-"2000"
 plate2[paste0(c("B","C","D","E","F","G"),rep(c(1,5,9)+3,each=6)),"Set"]<-"1000"

 plate4[paste0(c("B","C","D","E","F","G"),2),"Groups"]<-"thioQ(OAc)5"
 plate4[paste0(c("B","C","D","E","F","G"),3),"Groups"]<-"thioQ"
 plate4[paste0(c("B","C","D","E","F","G"),4),"Groups"]<-"thioQ(OAc)4"
 plate4[paste0(c("B","C","D","E","F","G"),5),"Groups"]<-"Q"
 plate4[paste0(c("B","C","D","E","F","G"),6),"Groups"]<-"CTR"
 plate4[paste0(c("B","C","D","E","F","G"),7),"Groups"]<-"thioQ(OAc)4\nnew"
 plate4[paste0(c("B","C","D","E","F","G"),rep(2:7,each=6)),"Set"]<-"8000a"
 
 dotplot<-function(plate=plate,test="Mann-Whitney test",ylab="",colx="Groups",coly="Area",title=project,color="Groups"){
   all_pv<-data.frame()
   p<-ggpubr::ggboxplot(plate, x = colx, y = coly, color=color, add = "jitter",palette = c("black","red","orange","blue","green")[1:length(unique(plate[,color]))]) + # , palette = "jco", label = paste0(test,", p.value = {p.value}")
     ggplot2::theme_bw(base_size = 18) + ggplot2::theme(legend.position="none",title = ggplot2::element_text(size = 14),axis.text = ggplot2::element_text(size = 12,face="bold",colour="black")) + ggplot2::labs(x=colx,y=ylab, title = paste0(title,", p.value"))
   if(test %in% c("Mann-Whitney test","t-test")){
     # gplots::heatmap.2(plate,scale="row",col=gplots::greenred(75),na.rm=TRUE, key=TRUE, density.info="none", trace="none",mar=c(10,10),cexRow = 1)
     # tmp<-data.frame(colx=as.factor(cat[1]),y=as.numeric(data[i,colData[colData$Gr==cat[1],"Name"]]),check.names = FALSE)
     # for(j in cat[-1]) tmp<-rbind(tmp, data.frame(colx=as.factor(j),y=as.numeric(data[i,colData[colData$Gr==j,"Name"]]),check.names = FALSE) )
     gr<-as.character(unique(plate[,colx]))
     x<-combn(gr,2)[,1]
     my_pv<-data.frame(t(combn(gr[table(plate[,colx])>1],2,function(x) c(x,
                                                  signif(mean(plate[plate[,colx]==x[1],2]),2),
                                                  signif(mean(plate[plate[,colx]==x[2],2]),2),
                                                  signif(log(signif(mean(plate[plate[,colx]==x[1],2]),2),2)-log(signif(mean(plate[plate[,colx]==x[2],2]),2),2),2),
                                                  if(test=="t-test"){ signif(t.test(plate[plate[,colx]==x[1],2],plate[plate[,colx]==x[2],2],p.adjust.method="none")$p.value,2)
                                                  } else signif(wilcox.test(plate[plate[,colx]==x[1],2],plate[plate[,colx]==x[2],2],p.adjust.method="none")$p.value,2)
     ), simplify = T)))
     
     colnames(my_pv)<-c("group1","group2","mean1","mean2","logFC","p.value")
     my_pv<-my_pv[!is.nan(my_pv[,"p.value"]) & my_pv[,"p.value"]!="NaN",]
     # all_pv<-rbind(all_pv,cbind(Name=rep(i,nrow(my_pv)),my_pv))
     my_pv<-my_pv[order(as.numeric(my_pv$p.value)),]
     all_pv<-my_pv<-cbind(my_pv,FDR=signif(p.adjust(as.numeric(my_pv$p.value),method = "fdr"),2))
     
     my_pv_FDR<-my_pv[as.numeric(my_pv[,"FDR"])<=0.05,]
     # print(ggpubr::ggboxplot(plate, x = colx, y = coly, fill=colx, add = "jitter") + # , palette = "jco", label = paste0(test,", adj. p.value = {FDR}")
     #         ggplot2::theme_bw(base_size = 18) + ggplot2::theme(legend.position="none",title = ggplot2::element_text(size = 14)) + ggplot2::labs(x=colx,y=ylab, title = paste0(title,", adj. p.value")) + 
     #         ggpubr::stat_pvalue_manual( my_pv_FDR,label = "{FDR}", tip.length = 0.01, y.position = seq(round(max(plate[,coly]))*1.01,
     #                         round(max(plate[,coly]))*1.2, length.out=nrow(my_pv_FDR) ), bracket.shorten = 0.05))
  
     my_pv<-my_pv[as.numeric(my_pv[,"p.value"])<=0.05,]
     p<-p + ggpubr::stat_pvalue_manual( my_pv,label = "{p.value}", tip.length = 0.01, bracket.shorten = 0.05,
                  y.position = seq(round(max(plate[,coly]))*1.01, round(max(plate[,coly]))*1.2, length.out=nrow(my_pv) ))
   }
   print(p)
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
 
 colnames(plate1)
 colnames(plate2)
 colnames(plate4)
 
 plate4<-plate4[!rownames(plate4) %in% c("B5","G7"),]
 
 plate<-rbind(plate1,plate2,plate4)[,c("Groups","Area","Set")]
 plate$Area<-as.numeric(plate$Area)
 colnames(plate)[colnames(plate)=="Area"]<-"y"
 # plate$Groups<- factor(plate$Groups,levels = c("thioQ(OAc)5","thioQ(OAc)5+I","thioQ","thioQ+I","thioQ(OAc)4","thioQ(OAc)4+I","Q4","Q+I","I","K","CTR"))
 # plate$Set<- factor(plate$Set,levels = c("1000","2000","4000","8000"))
 plate$Exp<-project
 plate$value<-"Spheroids area, px^2"
 plate<-plate[!(grepl("I",plate$Groups) | plate$Groups=="K"),]

 # wbT<-openxlsx::createWorkbook()
 # ylab="Spheroids area, px^2"
 # pdf(paste0("data/",project,".pdf"), width = 5, height = 5)
 # plateS<-plate[!(grepl("I",plate$Groups) | plate$Groups=="K"),]
 # 
 # # for(s in unique(plateS$Set)){
 # #   r<-plateS[plateS$Set==s,]
 # #   r<-r[r$Groups!="Kdmso white",]
 # #   plateS<-r
 # #   plateS$y=r$y/median(r$y[r$Groups=="CTR"])*100
 # #   write2xlsx(dotplot(plate=r,test="t-test",ylab=unique(r$value),colx="Groups",coly="y",title=paste(e,"\n",s,"t-test")),wb = wb,sheet = paste(s,"t-test"))
 # #   write2xlsx(dotplot(plate=plateS,test="t-test",ylab=paste0(unique(r$value),", % of CTR"),colx="Groups",coly="y",title=paste(e,"\n",s,"t-test")),wb = wb,sheet = paste(s,"%, t-test"))
 #   
 # write2xlsx(dotplot(plate=plateS,test="t-test",ylab=ylab,title="t-test"),wb = wbT,sheet = "t-test")
 # # write2xlsx(dotplot(plate=plateS,test="Mann-Whitney test",ylab=ylab,title="Mann-Whitney test"),wb = wbT,sheet = "Mann-Whitney test")
 # 
 # # print(ggpubr::ggviolin(plate, x = "Groups", y = "Area", fill="Groups", add = "jitter") + # , palette = "jco"
 # #         ggplot2::theme_bw(base_size = 18) + ggplot2::theme(legend.position="none",title = ggplot2::element_text(size = 14)) + ggplot2::labs(x="Groupss",y=ylab, title = project) )
 # print(ggpubr::ggboxplot(plate, x = "Groups", y = "Area", fill="Groups", add = "jitter") + # , palette = "jco"
 #         ggplot2::theme_bw(base_size = 18) + ggplot2::theme(legend.position="none",title = ggplot2::element_text(size = 14)) + ggplot2::labs(x="Compounds",y=ylab, title = project) )
 # write2xlsx(dotplot(plate=plate,test="t-test",ylab=ylab,title="t-test"),wb = wbT,sheet = "All t-test")
 # # write2xlsx(dotplot(plate=plate,test="Mann-Whitney test",ylab=ylab,title="Mann-Whitney test"),wb = wbT,sheet = "All Mann-Whitney test")
 # # }
 # openxlsx::saveWorkbook(wbT,paste0("data/",project,"_",format(Sys.time(), "%Y-%m-%d"),".xlsx"),overwrite = TRUE)
 # dev.off()
 # 
 
 
 #### TODO: В этих 2-х экспериментах надо сравнить  статистическую достоверность ОД450  для контрольных лунок  К, Кдмсо и лунок где были добавлены вещества thioQ(OAc)5, thioQ, thioQ(OAc)4  Q, ####
 #### TODO: причем сравнивать надо  лунки с одинаковым количеством клеток 8000 с  8000, 4000 с 4000 итд. Во втором эксперименте ты уже считал площади сфероидов. ####

 d<-openxlsx::read.xlsx("Nadja_20250703.xlsx")
 d<-d[!is.na(d$y),]
 d$Set[is.na(d$Set)]<-""
 d$Groups[d$Groups=="thioQ(OAc)4 new"]<-"thioQ(OAc)4\nnew"
 d<-rbind(plate,d)
 
 d<-d[d$Groups!="thioQ(OAc)4\nnew",]
 d<-d[d$Groups!="Kdmso white",]
   
 Groups<-unique(d$Groups)
 CanGroups<-c("CTR","Q","thioQ","thioQ(OAc)4","thioQ(OAc)5")
 d$Groups<- factor(d$Groups,levels = c(CanGroups,Groups[!Groups %in% CanGroups]))
 
 b<-d[d$Exp=="Spheroids formation in the presence of chemical compounds" & d$Set=="8000",]
 a<-aggregate(b$y,list(b$Groups),mean)
 d<-rbind(d,data.frame(Groups=as.character(a[,1]),y=as.double(a[,2]),Set="merged",Exp="Spheroids formation in the presence of chemical compounds",value="Spheroids area, px^2"))
 d<-rbind(d,data.frame(Groups=as.character(a[,1]),y=as.double(a[,2])/a[a[,1]=="CTR",2]*100,Set="merged in %",Exp="Spheroids formation in the presence of chemical compounds",value="Spheroids area, px^2"))
 d<-rbind(d,data.frame(Groups=b$Groups,y=b$y/a[a[,1]=="CTR",2]*100,Set="union",Exp="Spheroids formation in the presence of chemical compounds",value="Spheroids area, px^2"))
 b<-d[d$Exp=="Spheroids formation in the presence of chemical compounds" & d$Set=="8000a",]
 a<-aggregate(b$y,list(b$Groups),mean)
 d<-rbind(d,data.frame(Groups=as.character(a[,1]),y=as.double(a[,2]),Set="merged",Exp="Spheroids formation in the presence of chemical compounds",value="Spheroids area, px^2"))
 d<-rbind(d,data.frame(Groups=as.character(a[,1]),y=as.double(a[,2])/a[a[,1]=="CTR",2]*100,Set="merged in %",Exp="Spheroids formation in the presence of chemical compounds",value="Spheroids area, px^2"))
 d<-rbind(d,data.frame(Groups=b$Groups,y=b$y/a[a[,1]=="CTR",2]*100,Set="union",Exp="Spheroids formation in the presence of chemical compounds",value="Spheroids area, px^2"))

 b<-d[d$Exp=="A-375 spheroid formation in Matrigel in 8 days" & d$Set=="250 cell/well",]
 a<-aggregate(b$y,list(b$Groups),mean)
 d<-rbind(d,data.frame(Groups=as.character(a[,1]),y=as.double(a[,2]),Set="merged",Exp="A-375 spheroid formation in Matrigel in 8 days",value="Spheroids number"))
 d<-rbind(d,data.frame(Groups=as.character(a[,1]),y=as.double(a[,2])/a[a[,1]=="CTR",2]*100,Set="merged in %",Exp="A-375 spheroid formation in Matrigel in 8 days",value="Spheroids number"))
 d<-rbind(d,data.frame(Groups=b$Groups,y=b$y/a[a[,1]=="CTR",2]*100,Set="union",Exp="A-375 spheroid formation in Matrigel in 8 days",value="Spheroids number"))
 b<-d[d$Exp=="A-375 spheroid formation in Matrigel in 8 days" & d$Set=="sep 250 cell/well",]
 a<-aggregate(b$y,list(b$Groups),mean)
 d<-rbind(d,data.frame(Groups=as.character(a[,1]),y=as.double(a[,2]),Set="merged",Exp="A-375 spheroid formation in Matrigel in 8 days",value="Spheroids number"))
 d<-rbind(d,data.frame(Groups=as.character(a[,1]),y=as.double(a[,2])/a[a[,1]=="CTR",2]*100,Set="merged in %",Exp="A-375 spheroid formation in Matrigel in 8 days",value="Spheroids number"))
 d<-rbind(d,data.frame(Groups=b$Groups,y=b$y/a[a[,1]=="CTR",2]*100,Set="union",Exp="A-375 spheroid formation in Matrigel in 8 days",value="Spheroids number"))

 e<-"Spheroids formation in the presence of chemical compounds"
 wbR<-openxlsx::createWorkbook()
 for(e in unique(d$Exp)){
   wb<-openxlsx::createWorkbook()
   pdf(paste0("data/",e,"_",format(Sys.time(), "%Y-%m-%d"),".pdf"), width = 6.5, height = 5)
   for(s in unique(d$Set[d$Exp==e])){
     r<-d[d$Exp==e & d$Set==s,]
     r<-r[r$Groups!="Kdmso white",]
     plateS<-r
     plateS$y=r$y/median(r$y[r$Groups=="CTR"])*100
     plateS$color<-"2"
     plateS$color[plateS$Groups=="CTR"]<-"1"
     plateS$color[plateS$Groups=="Q"]<-"3"
     # write2xlsx(dotplot(plate=r,test="t-test",ylab=unique(r$value),colx="Groups",coly="y",title=paste(e,"\n",s,"t-test")),wb = wb,sheet = paste(s,"t-test"))
     tmp<-dotplot(plate=plateS,test="t-test",ylab=paste0(unique(r$value),", % of CTR"),colx="Groups",coly="y",title=paste(e,"\n",s,"t-test"))
     write2xlsx(tmp, wb = wb,sheet = paste(s,"%, t-test"))
     write2xlsx(dotplot(plate=plateS,test="none",ylab=paste0(unique(r$value),", % of CTR"),colx="Groups",coly="y",title=paste(e,"\n",s),color = "color"),wb = wb,sheet = paste(s,"%"))
     if((e=="Spheroids formation in the presence of chemical compounds" & s=="union") | 
        (e=="A-375 spheroid formation in Matrigel in 8 days" & s=="union")){
       sheet<-"Multicellular spheroid-formation"
       if(e=="A-375 spheroid formation in Matrigel in 8 days") sheet<-"Clonal spheroid-formation"
       write2xlsx(data.frame(Group=as.character(plateS$Groups[order(plateS$Groups,plateS$y)]),"Percent of CTR"=round(plateS$y[order(plateS$Groups,plateS$y)], 2),check.names = F), wb = wbR, sheet = sheet) # ,Area=r$y
       write2xlsx(tmp, wb = wbR, sheet = paste0("t-test, ",sheet))
       # write2xlsx(aggregate(plateS$y,list(plateS$Groups),median), wb = wbR, sheet = paste("median",e))
     }
     # write2xlsx(dotplot(plate=r,test="Mann-Whitney test",ylab=unique(r$value),colx="Groups",coly="y",title=paste(e,"\n",s,"Mann-Whitney test")),wb = wb,sheet = paste(s,"Mann-Whitney test"))
     # write2xlsx(dotplot(plate=plateS,test="Mann-Whitney test",ylab=paste0(unique(r$value),", % of CTR"),colx="Groups",coly="y",title=paste(e,"\n",s,"Mann-Whitney test")),wb = wb,sheet = paste(s,"%, Mann-Whitney test"))
   }
   dev.off()
   openxlsx::saveWorkbook(wb,paste0("data/",e,"_",format(Sys.time(), "%Y-%m-%d"),".xlsx"),overwrite = TRUE)
 }
 openxlsx::saveWorkbook(wbR,paste0("data/Spheroid_assays_Figure_2B.xlsx"),overwrite = TRUE)
 
 
 