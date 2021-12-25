subroutine TensorTrans(stressin,trans_matrix,stressout)
!tensor transformation:stressout=transpose(trans_matrix)*stressin*trans_matrix
![e1 e2 e3]=[E1 E2 E3]*trans_matrix. e1,e2,e3 are the basis vectors of the new
!coordinate system, E1,E2,E3 are the basis vecotors of the old coordinate system.
!stressin is the stress tensor in the old coordinate system. stressout is the stress tensor
!in the new coordinate system. 
!
implicit none
!
real*8 stressin(3,3),trans_matrix(3,3),stressout(3,3)
real*8 temp1(3,3),temp2(3,3)
!temp1=stressin*trans_matrix
call MatrixProduct(stressin,trans_matrix,temp1)
!temp2=trans_matrix'
call MatrixTranspose(trans_matrix,temp2)
!stressout=temp2*temp1
call MatrixProduct(temp2,temp1,stressout)
end
!-----------------------------------!
subroutine MatrixProduct(A,B,C)
!C=A*B
!
implicit none
!
real*8 A(3,3),B(3,3),C(3,3)
real*8 temp
integer*4 i,j,k
do 100 i=1,3
 do 200 j=1,3
    temp=0.0
    do 300 k=1,3
       temp=temp+A(i,k)*B(k,j)
    300 continue
    C(i,j)=temp
  200 continue
100 continue
end
!-----------------------------------!
subroutine MatrixTranspose(A,B)
!B=A'
!
implicit none
!
real*8 A(3,3),B(3,3)
integer*4 i,j
do 100 i=1,3
   do 200 j=1,3
    B(i,j)=A(j,i)
   200 continue 
100 continue
end
