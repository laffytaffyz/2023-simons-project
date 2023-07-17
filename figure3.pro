; figure3.pro        by: tiffany zhang
; creates plot for each specific e_q value with bands of specified BNS, BHNS, gap, and BBH merger probabilities
; note: mch and q estimates and the confidence interval have not been added yet
;

pro figure3

; plot characteristics
!P.thick=3
!P.charthick=3
!P.charsize=2

; loads data 
data = READ_CSV("C:\Users\Tiffany\IDLWorkspace\Default\merger_prob_data.csv", HEADER=headers)
e_q_arr = data.field3
e_q_arr = e_q_arr[uniq(e_q_arr, sort(e_q_arr))]

; specified merger probabilities
candidate_p_bns = 0.15
candidate_p_bhns = 0.60
candidate_p_gap = 0.25
candidate_p_bbh = 0.00
candidate_p_ns = 0.01

; creates plot for every e_q 
for i=0,12 do begin
  e_q = e_q_arr(i)

  ; calculates the range of mch and q values for the plot
  mch_0 = (data.field1)(where(data.field3 eq e_q))
  mch_0 = mch_0(uniq(mch_0))
  q_0 = (data.field2)(where(data.field3 eq e_q))
  q_0 = q_0[uniq(q_0, sort(reverse(q_0)))]

  ; calculates and creates contours for m1 and m2 values
  m1 = fltarr(51,51)
  m2 = fltarr(51,51)
  q = exp(q_0)+1
  for j=0,50 do begin
    m1(j,*)=mch_0(j)*(1+q)^.2*q^.4
    m2(j,*)=m1(j,*)/q
  endfor  
  contour, m1, mch_0, q_0, xtit='!13M!3 (M!D!9n!3!N)',ytit='!sq!r!a-!n',xst=1,yst=1,xr=[0.5, 4.5],yr=[-3,4],lev=[3,5],c_lab=1+intarr(10),/noclip,c_chars=1.2,c_li=1
  contour, m2, mch_0, q_0, xst=1,yst=1,xr=[0.5, 4.5],yr=[-3,4],lev=[1,1.4,2,3],c_lab=1+intarr(10),/noerase,/noclip,c_chars=1.2,c_li=1
  
  ; changes data from .csv file into 2D array corresponding to e_q for plotting
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

  ; creates bands for each merger probability
  ; BNS
  if (candidate_p_bns gt 0) then begin
    contour, p_bns, mch_0, q_0, xst=1,yst=1,lev=[candidate_p_bns-0.025,candidate_p_bns+0.025], xr=[0.5, 4.5],yr=[-3,4],/noerase,/noclip,path_xy=xy,path_info=info_bns,/PATH_DATA_COORDS,closed=0
    xy_bns=[]
    for j=0,info_bns(0).N-1 do xy_bns = [[xy_bns],[xy(*,j)]]
    for j=0,info_bns(1).N-1 do xy_bns = [[xy_bns],[xy(*, info_bns(1).offset+info_bns(1).n-1-j)]]
    polyfill, xy_bns, color=150
  endif

  ; BHNS
  if (candidate_p_bhns gt 0) then begin
    contour, p_bhns, mch_0, q_0, xst=1,yst=1,lev=[candidate_p_bhns-0.025,candidate_p_bhns+0.025], xr=[0.5, 4.5],yr=[-3,4],/noerase,/noclip,path_xy=xy,path_info=info_bhns,/PATH_DATA_COORDS,closed=0
    xy_bhns=[]
    for j=0,info_bhns(0).N-1 do xy_bhns = [[xy_bhns],[xy(*,j)]]
    for j=0,info_bhns(1).N-1 do xy_bhns = [[xy_bhns],[xy(*, info_bhns(1).offset+info_bhns(1).n-1-j)]]
    polyfill, xy_bhns, color=250
  endif

  ; gap
  if (candidate_p_gap gt 0) then begin
    contour, p_gap, mch_0, q_0, xst=1,yst=1,lev=[candidate_p_gap-0.025,candidate_p_gap+0.025], xr=[0.5, 4.5],yr=[-3,4],/noerase,/noclip,path_xy=xy,path_info=info_gap,/PATH_DATA_COORDS,closed=0
    
    if (size(info_gap, /n_elements) eq 4) then begin
        xy_gap1=[]
        for j=0,info_gap(0).N-1 do xy_gap1 = [[xy_gap1],[xy(*,j)]]
        for j=0,info_gap(2).N-1 do xy_gap1 = [[xy_gap1],[xy(*,info_gap(2).offset+info_gap(2).n-1-j)]]
        polyfill, xy_gap1,color=50

        xy_gap2=[]
        for j=0,info_gap(1).N-1 do xy_gap2 = [[xy_gap2],[xy(*,info_gap(1).offset+j)]]
        for j=0,info_gap(3).N-1 do xy_gap2 = [[xy_gap2],[xy(*,info_gap(3).offset+info_gap(3).n-1-j)]]
        polyfill, xy_gap2,color=50
    endif 

    if (size(info_gap, /n_elements) eq 2) then begin
        xy_gap=[]
        for j=0,info_gap(0).N-1 do xy_gap = [[xy_gap],[xy(*,j)]]
        for j=0,info_gap(1).N-1 do xy_gap = [[xy_gap],[xy(*,info_gap(1).offset+info_gap(1).n-1-j)]]
        polyfill, xy_gap,color=50
    endif 
  endif

  ; BBH
  if (candidate_p_bbh gt 0) then begin
    contour, p_bbh, mch_0, q_0, xst=1,yst=1,lev=[candidate_p_bbh-0.025,candidate_p_bbh+0.025], xr=[0.5, 4.5],yr=[-3,4],/noerase,/noclip,path_xy=xy,path_info=info_bbh,/PATH_DATA_COORDS,closed=0
    xy_bbh=[]
    for j=0,info_bbh(0).N-1 do xy_bbh = [[xy_bbh],[xy(*,j)]]
    for j=0,info_bbh(1).N-1 do xy_bbh = [[xy_bbh],[xy(*, info_bbh(1).offset+info_bbh(1).n-1-j)]]
    polyfill, xy_bbh
  endif

  ; contour for probability of NS
  if (candidate_p_ns gt 0) then contour, p_ns, mch_0, q_0, xst=1,yst=1,lev=[candidate_p_ns], xr=[0.5, 4.5],yr=[-3,4],/noerase,/noclip,c_li=1,c_color=250
  
  ; label for e_q
  xyouts,3,2.5,'!4' + String("162B) + '!X'+'!Dq!N ='+STRING(e_q,FORMAT='(F5.2)')
endfor

;DEVICE, /CLOSE
end