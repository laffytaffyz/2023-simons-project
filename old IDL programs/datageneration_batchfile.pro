; homework 07/11/2023 (batch file)        by tiffany
; batch file version of homework07112023.pro to run in cmd
; 

;pro homework07112023ver2batchfile

n=501 ; size of grid
n_int = 50 ; size of subgrids
dmch=5./(n-1) 
dq=23./(n-1)
mch=0.0+dmch*indgen(n) ; range of mch values
q=12-dq*indgen(n) ; range of q values

; looping based on mch_0 value
for i1=0, n_int do begin $
  mch_0=0.5+4./n_int*i1 & $
  
  ; looping based on q_0 value
  for i2=0, n_int do begin & $
    q_0=4-7./n_int*i2 & $

    ; looping based on different errors for q
    for j=0, 12 do begin & $
      e_q = 1+0.25*j & $
      e_mch = 0.01 & $
      
      print, mch_0, q_0, e_q & $
      
      dp = fltarr(n,n) & $
      for k=0, n-1 do dp(k,*) = exp(-0.5*((mch(k) - mch_0)/e_mch)^2-0.5*((q - q_0)/e_q)^2)/(2*!pi*e_mch*e_q) & $
      
      ; calculating m1 and m2 in terms of axis
      m1=fltarr(n,n)& $
      m2=m1 & $
      realq=exp(q)+1 & $
      for k=0,n-1 do begin & $
        m1(k,*)=mch(k)*(1+realq)^.2*realq^.4 & $
        m2(k,*)=m1(k,*)/realq & $
      endfor & $
    
;      print, max(dp), min(dp)
;      print, "p" + STRING(total(dp*dmch*dq))
    
      ; merger probability calculation
      p_bns=total(dp(where(m1 lt 3))*dmch*dq) & $
      p_bhns=total(dp(where(m1 gt 5 and m2 lt 3))*dmch*dq) & $
      p_bbh=total(dp(where(m2 gt 5))*dmch*dq) & $
      p_gap=total(dp(where((m1 gt 3 and m1 lt 5) or (m2 gt 3 and m2 lt 5)))*dmch*dq) & $
      p_ns=total(dp(where(m2 lt 2.25))*dmch*dq) & $
      
      ; concat data to csv
      if ((i1 eq 0) and (i2 eq 0) and (j eq 0)) then csv_arr = [mch_0, q_0, e_q, p_bns, p_bhns, p_bbh, p_gap, p_ns] else csv_arr = [[csv_arr],[mch_0, q_0, e_q, p_bns, p_bhns, p_bbh, p_gap, p_ns]] & $
      
;      print, p_bns, p_bhns, p_bbh, p_gap, p_ns & $
;      print, ' ' & $
      
;      ; CREATES COUNTOUR GRAPH OF GAUSSIAN CURVE AND MERGER PARAMETERS
;      contour,dp,mch,q,xtit='!13M!3 (M!D!9n!3!N)',ytit='!sq!r!a-!n',xst=1,yst=1,xr=[0.5,4.5],yr=[-3,4],lev=[exp(-4)/(2*!pi*e_mch*e_q),exp(-1)/(2*!pi*e_mch*e_q)],c_lab=1
;      contour,m1,mch,q,xst=1,yst=1,xr=[0.5,4.5],yr=[-3,4],lev=[3],/noerase,c_li=2
;      contour,m2,mch,q,xst=1,yst=1,xr=[0.5,4.5],yr=[-3,4],lev=[3],/noerase,c_li=2
;      
;      xyouts,3.5,3.2,'!13M!3!D0!N ='+STRING(mch_0,FORMAT='(F5.1)')
;      xyouts,3.5,2.7,'!sq!r!a-!n!D0!N ='+STRING(q_0,FORMAT='(F5.1)')
;      xyouts,3.5,2.2,'!4' + String("162B) + '!X'+'!Dq!N ='+STRING(e_q,FORMAT='(F5.1)')
    endfor & $
  endfor & $
 endfor & $

; writes csv and saves it
write_csv, "merger_prob_data.csv", csv_arr, header=["mch_0", "q_0", "e_q", "p_bns", "p_bhns", "p_bbh", "p_gap", "p_ns"] & $

end
