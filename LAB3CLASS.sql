--CAU 1--
USE QuanLyBanHang
GO

--12.Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”, mỗi sản phẩm mua với số lượng từ 10 đến 20. --
SELECT SOHD
FROM CTHD
WHERE (MASP = 'BB01' OR MASP = 'BB02') AND (SL BETWEEN 10 AND 20)

--13. Tìm các số hóa đơn mua cùng lúc 2 sản phẩm có mã số “BB01” và “BB02”, mỗi sản phẩm mua với số lượng từ 10 đến 20. --
SELECT SOHD
FROM CTHD
WHERE (MASP = 'BB01' AND SL BETWEEN 10 AND 20)
   OR (MASP = 'BB02' AND SL BETWEEN 10 AND 20)
GROUP BY SOHD

--CAU 2--

USE QuanLyHocVu
GO

--1.Tăng hệ số lương thêm 0.2 cho những giáo viên là trưởng khoa.--
UPDATE GIAOVIEN
SET HESO = HESO + 0.2
WHERE MAGV IN (SELECT TRGKHOA FROM KHOA);

--2.Cập nhật giá trị điểm trung bình tất cả các môn học (DIEMTB) của mỗi học viên (tất cả các môn học đều có hệ số 1 và nếu học viên thi một môn nhiều lần, chỉ lấy điểm của lần thi sau cùng).--
UPDATE HocVien
SET DiemTB =
(
	SELECT AVG(Diem)
	FROM KetQuaThi
	WHERE LanThi = (SELECT MAX(LanThi) FROM KetQuaThi KQ WHERE MaHV = KetQuaThi.MaHV GROUP BY MaHV)
	GROUP BY MaHV
	HAVING MaHV = HocVien.MaHV
)

--3.Cập nhật giá trị cho cột GHICHU là “Cam thi” đối với trường hợp: học viên có một môn bất kỳ thi lần thứ 3 dưới 5 điểm--
UPDATE HOCVIEN
SET GHICHU = N'Cam thi'
WHERE EXISTS 
(
    SELECT 1
    FROM KETQUATHI 
    WHERE KETQUATHI.MAHV = HOCVIEN.MAHV
      AND KETQUATHI.LANTHI = 3
      AND KETQUATHI.DIEM < 5
)

--4--
UPDATE HOCVIEN
SET XEPLOAI = CASE
    WHEN DIEMTB >= 9 THEN 'XS'
    WHEN DIEMTB >= 8 AND DIEMTB < 9 THEN 'G'
    WHEN DIEMTB >= 6.5 AND DIEMTB < 8 THEN 'K'
    WHEN DIEMTB >= 5 AND DIEMTB < 6.5 THEN 'TB'
    WHEN DIEMTB < 5 THEN 'Y'
END

--CAU 3--
--6.Tìm tên những môn học mà giáo viên có tên “Tran Tam Thanh” dạy trong học kỳ 1 năm 2006.--
SELECT MONHOC.MAMH
FROM  MONHOC
JOIN GIANGDAY ON GIANGDAY.MAMH = MONHOC.MAMH
JOIN GIAOVIEN ON GIANGDAY.MAGV = GIAOVIEN.MAGV
WHERE HOTEN = 'Tran Tam Thanh' AND HOCKY = 1 AND NAM = 2006

--7.tìm những môn học (mã môn học, tên môn học) mà giáo viên chủ nhiệm lớp “K11” dạy trong học kỳ 1 năm 2006.--
SELECT DISTINCT MONHOC.MAMH, MONHOC.TENMH
FROM MONHOC 
JOIN GIANGDAY ON MONHOC.MAMH = GIANGDAY.MAMH
JOIN LOP ON GIANGDAY.MALOP = LOP.MALOP
WHERE LOP.MALOP = 'K11'
    AND GIANGDAY.HOCKY = 1
    AND GIANGDAY.NAM = 2006

--8.Tìm họ tên lớp trưởng của các lớp mà giáo viên có tên “Nguyen To Lan” dạy môn “Co So Du Lieu”.--
SELECT HOCVIEN.HO,HOCVIEN.TEN
FROM HOCVIEN
JOIN LOP ON HOCVIEN.MAHV = LOP.TRGLOP
JOIN GIANGDAY ON GIANGDAY.MALOP = LOP.MALOP
JOIN GIAOVIEN ON GIAOVIEN.MAGV = GIANGDAY.MAGV
JOIN MONHOC ON GIANGDAY.MAMH = MONHOC.MAMH
WHERE GIAOVIEN.HOTEN = 'Nguyen To Lan' AND MONHOC.TENMH = 'Co So Du Lieu'

--9.In ra danh sách những môn học (mã môn học, tên môn học) phải học liền trước môn “Co So Du Lieu”.--
SELECT DIEUKIEN.MAMH_TRUOC, MONHOC.TENMH
FROM DIEUKIEN 
JOIN MONHOC ON DIEUKIEN.MAMH_TRUOC = MONHOC.MAMH
WHERE DIEUKIEN.MAMH = (SELECT MAMH 
                 FROM MONHOC 
                 WHERE TENMH = 'Co So Du Lieu');

--10.Môn “Cau Truc Roi Rac” là môn bắt buộc phải học liền trước những môn học (mã môn học, tên môn học) nào. --
SELECT MONHOC.MAMH
FROM MONHOC
JOIN DIEUKIEN ON DIEUKIEN.MAMH = MONHOC.MAMH
WHERE	DIEUKIEN.MAMH_TRUOC = (SELECT MAMH 
                        FROM MONHOC 
                        WHERE TENMH = 'Cau Truc Roi Rac')

--Cau 04--
USE QuanLyBanHang
GO

-- 14. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất hoặc các sản phẩm được bán ra trong ngày 1/1/2007.--
SELECT SANPHAM.MASP,TENSP
FROM SANPHAM
JOIN CTHD ON CTHD.MASP = SANPHAM.MASP
JOIN HOADON ON HOADON.SOHD = CTHD.SOHD
WHERE SANPHAM.NUOCSX = 'Trung Quoc' OR HOADON.NGHD = '1/1/2007'

-- 15. In ra danh sách các sản phẩm (MASP,TENSP) không bán được. --
SELECT SANPHAM.MASP,TENSP
FROM SANPHAM
LEFT JOIN CTHD ON CTHD.MASP = SANPHAM.MASP
WHERE CTHD.MASP IS NULL

-- 16. In ra danh sách các sản phẩm (MASP,TENSP) không bán được trong năm 2006. --
SELECT SANPHAM.MASP,TENSP
FROM SANPHAM
LEFT JOIN CTHD ON CTHD.MASP = SANPHAM.MASP
LEFT JOIN HOADON ON HOADON.SOHD = CTHD.SOHD
WHERE YEAR(NGHD) != 2006 OR NGHD IS NULL
-- 17. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất không bán được trong năm 2006. --
SELECT SANPHAM.MASP,TENSP
FROM SANPHAM
LEFT JOIN CTHD ON CTHD.MASP = SANPHAM.MASP
LEFT JOIN HOADON ON HOADON.SOHD = CTHD.SOHD
WHERE (YEAR(NGHD) != 2006 OR NGHD IS NULL) AND (NUOCSX = 'Trung Quoc')
-- 18. Tìm số hóa đơn trong năm 2006 đã mua ít nhất tất cả các sản phẩm do Singapore sản xuất. --
SELECT HOADON.SOHD
FROM HOADON 
JOIN CTHD ON HOADON.SOHD = CTHD.SOHD
JOIN SANPHAM ON CTHD.MASP = SANPHAM.MASP
WHERE HOADON.NGHD BETWEEN '2006-01-01' AND '2006-12-31'
  AND SANPHAM.NUOCSX = 'Singapore'
GROUP BY HOADON.SOHD
HAVING COUNT(DISTINCT SANPHAM.MASP) = (SELECT COUNT(*) 
                                 FROM SANPHAM 
                                 WHERE NUOCSX = 'Singapore')
--Bai05--
					

--Cau 11--
SELECT HoTen
FROM GIAOVIEN, GIANGDAY
WHERE GiaoVien.MaGV = GiangDay.MAGV
AND MaLop = 'K11'
AND HocKy = 1 AND Nam = 2006
INTERSECT (SELECT HoTen FROM GiaoVien, GiangDay
	   WHERE GiaoVien.MaGV = GiangDay.MaGV
	   AND MaLop = 'K12' AND HocKy = 1 AND Nam = 2006)

--Cau 12--
SELECT HocVien.MaHV, (Ho+' '+Ten) HoTen
FROM HocVien, KetQuaThi
WHERE HocVien.MaHV = KetQuaThi.MaHV
	AND MaMH = 'CSDL' AND LanThi = 1 AND KQua = 'Khong Dat'
	AND NOT EXISTS (SELECT * FROM KetQuaThi WHERE LanThi > 1 AND KetQuaThi.MaHV = HocVien.MaHV)

--Cau 13--
SELECT MaGV, HoTen
FROM GiaoVien
WHERE MaGV NOT IN (SELECT MaGV FROM GiangDay)

		--Cau 14--
SELECT MaGV, HoTen
FROM GiaoVien
WHERE NOT EXISTS
(
	SELECT *
	FROM MonHoc
	WHERE MonHoc.MaKhoa = GiaoVien.MaKhoa
	AND NOT EXISTS
	(
		SELECT *
		FROM GiangDay
		WHERE GiangDay.MaMH = MonHoc.MaMH
		AND GiangDay.MaGV = GiaoVien.MaGV
	)
)

--Cau 15--
SELECT DISTINCT (Ho+' '+Ten) HoTen
FROM HocVien, KetQuaThi
WHERE HocVien.MaHV = KetQuaThi.MaHV
	AND MaLop = 'K11'
	AND ((LanThi = 2 AND Diem = 5)
	OR HocVien.MaHV IN
	(
		SELECT DISTINCT MaHV
		FROM KetQuaThi
		WHERE KQua = 'Khong Dat'
		GROUP BY MaHV, MaMH
		HAVING COUNT(*) > 3	
	)
)

		--Cau 16--
SELECT HoTen
FROM GiaoVien, GiangDay
WHERE GiaoVien.MaGV = GiangDay.MaGV
	AND MaMH = 'CTRR'
GROUP BY GiaoVien.MaGV, HoTen, HocKy
HAVING COUNT(*) >= 2

--Cau 17--
SELECT HocVien.*, Diem AS 'Diem thi CSDL sau cung'
FROM HocVien, KetQuaThi
WHERE HocVien.MaHV = KetQuaThi.MaHV
	AND MaMH = 'CSDL'
	AND LanThi = 
	(
		SELECT MAX(LanThi) 
		FROM KetQuaThi 
		WHERE MaMH = 'CSDL' AND KetQuaThi.MaHV = HocVien.MaHV 
		GROUP BY MaHV
	)

--Cau 18--
SELECT HocVien.*, Diem AS 'Diem thi cao nhat'
FROM HocVien, KetQuaThi, MonHoc
WHERE HocVien.MaHV = KetQuaThi.MaHV
	AND KetQuaThi.MaMH = MonHoc.MaMH
	AND TenMH = 'Co So Du Lieu'
	AND Diem = 
		(
			SELECT MAX(Diem) 
			FROM KetQuaThi, MonHoc
			WHERE
				KetQuaThi.MaMH = MonHoc.MaMH
				AND MaHV = HocVien.MaHV
				AND TenMH = 'Co So Du Lieu'
			GROUP BY MaHV
		)
