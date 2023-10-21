; figure2.pro        by: tiffany zhang
; creates plot for each specified e_q value with contours of various BNS, BHNS, and BBH probabilities 
; 
; key to csv file
;

pro figure2

;; saves as postscript file
;SET_PLOT, 'PS'
;outfile = DIALOG_PICKFILE(FILE='figure2.ps', /WRITE, $
;  PATH=GETENV('IDL_TMPDIR'))
;DEVICE, FILE=outfile, /COLOR, BITS_PER_PIXEL=8

; plot characteristics
!P.thick=3
!P.charthick=3
!P.charsize=2

; loads data
data = READ_CSV("C:\Users\Tiffany\IDLWorkspace\Default\merger_prob_data.csv", HEADER=headers)

e_q_arr = data.field3
e_q_arr = e_q_arr[uniq(e_q_arr, sort(e_q_arr))]
print, e_q_arr

for i=0,12 do begin
  e_q = e_q_arr(i)

  mch_0 = (data.field1)(where(data.field3 eq e_q))
  mch_0 = mch_0(uniq(mch_0))
  q_0 = (data.field2)(where(data.field3 eq e_q))
  q_0 = q_0[uniq(q_0, sort(reverse(q_0)))]

  m1 = fltarr(51,51)
  m2 = fltarr(51,51)
  q = exp(q_0)+1
  for j=0,50 do begin
    m1(j,*)=mch_0(j)*(1+q)^.2*q^.4
    m2(j,*)=m1(j,*)/q
  endfor  

  p_bns = fltarr(51,51)
  p_bhns = fltarr(51,51)
  p_gap = fltarr(51,51)
  p_bbh = fltarr(51,51)
  p_ns = fltarr(51,51)
  for j=0, 50 do begin
    p_bns(j,*) = (data.field4)(where((data.field1 eq mch_0(j)) and (data.field3 eq e_q)))
    p_bhns(j,*) = (data.field5)(where((data.field1 eq mch_0(j)) and (data.field3 eq e_q)))
    p_gap(j,*) = (data.field7)(where((data.field1 eq mch_0(j)) and (data.field3 eq e_q)))
    p_bbh(j,*) = (data.field6)(where((data.field1 eq mch_0(j)) and (data.field3 eq e_q)))
    p_ns(j,*) = (data.field8)(where((data.field1 eq mch_0(j)) and (data.field3 eq e_q)))
  endfor

  ; note to self
  ; red = 250
  ; green = 150
  ; blue = 50

  contour, p_bns, mch_0, q_0, xst=1,yst=1,xtit='!13M!3 (M!D!9n!3!N)',ytit='!sq!r!a-!n',lev=[0.1,0.3,0.5,0.7,0.9], xr=[0.5, 4.5],yr=[-3,4],c_lab=1+intarr(10),/noclip,c_chars=1.2
  contour, p_gap, mch_0, q_0, xst=1,yst=1,lev=[0.1,0.3,0.5,0.7,0.9], xr=[0.5, 4.5],yr=[-3,4],c_lab=1+intarr(10),/noerase,/noclip,c_chars=1.2,color=50
  contour, p_bhns, mch_0, q_0, xst=1,yst=1,lev=[0.1,0.3,0.5,0.7,0.9], xr=[0.5, 4.5],yr=[-3,4],c_lab=1+intarr(10),/noerase,/noclip,c_chars=1.2,color=250
  contour, p_bbh, mch_0, q_0, xst=1,yst=1,lev=[0.1,0.3,0.5,0.7,0.9], xr=[0.5, 4.5],yr=[-3,4],c_lab=1+intarr(10),/noerase,/noclip,c_chars=1.2,color=150

  contour, p_bns, mch_0, q_0, xst=1,yst=1,lev=[0.01,0.99], xr=[0.5, 4.5],yr=[-3,4],/noerase,/noclip,c_li=2
  contour, p_gap, mch_0, q_0, xst=1,yst=1,lev=[0.01,0.99], xr=[0.5, 4.5],yr=[-3,4],/noerase,/noclip,c_li=2,color=50
  contour, p_bhns, mch_0, q_0, xst=1,yst=1,lev=[0.01,0.99], xr=[0.5, 4.5],yr=[-3,4],/noerase,/noclip,c_li=2,color=250
  contour, p_bbh, mch_0, q_0, xst=1,yst=1,lev=[0.01,0.99], xr=[0.5, 4.5],yr=[-3,4],/noerase,/noclip,c_li=2,color=150

  contour, m1, mch_0, q_0, xst=1,yst=1,lev=[3,5],c_lab=1+intarr(10),/noerase,/noclip,c_chars=1.2,c_li=1
  contour, m2, mch_0, q_0, xst=1,yst=1,lev=[1,1.4,2,3],c_lab=1+intarr(10),/noerase,/noclip,c_chars=1.2,c_li=1

  xyouts,3,2.5,'!4' + String("162B) + '!X'+'!Dq!N ='+STRING(e_q,FORMAT='(F5.2)')
endfor

;DEVICE, /CLOSE
end
