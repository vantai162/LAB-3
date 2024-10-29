
-- 8. Hiển thị tên và cấp độ của tất cả các kỹ năng của chuyên gia có MaChuyenGia là 1.
SELECT TenKyNang,CapDo
FROM ChuyenGia_KyNang
JOIN KyNang ON ChuyenGia_KyNang.MaKyNang = KyNang.MaKyNang
WHERE MaChuyenGia = 1

-- 9. Liệt kê tên các chuyên gia tham gia dự án có MaDuAn là 2.
SELECT HoTen
FROM ChuyenGia
JOIN ChuyenGia_DuAn ON ChuyenGia_DuAn.MaChuyenGia = ChuyenGia.MaChuyenGia
WHERE MaDuAn = 2

-- 10. Hiển thị tên công ty và tên dự án của tất cả các dự án.
SELECT TenCongTy,TenDuAn
FROM CongTy
JOIN DuAn ON CongTy.MaCongTy = DuAn.MaCongTy
-- 11. Đếm số lượng chuyên gia trong mỗi chuyên ngành.
SELECT ChuyenNganh, COUNT(MaChuyenGia) AS SoLuongChuyenGia
FROM ChuyenGia
GROUP BY ChuyenNganh


-- 12. Tìm chuyên gia có số năm kinh nghiệm cao nhất.
SELECT TOP 1 HoTen, NamKinhNghiem
FROM ChuyenGia
ORDER BY NamKinhNghiem DESC

-- 13. Liệt kê tên các chuyên gia và số lượng dự án họ tham gia.
SELECT HoTen,COUNT(DUAN.MaDuAn) AS SOLUONGDUAN
FROM ChuyenGia
JOIN ChuyenGia_DuAn ON ChuyenGia_DuAn.MaChuyenGia = ChuyenGia.MaChuyenGia
JOIN DuAn ON ChuyenGia_DuAn.MaDuAn = DuAn.MaDuAn
GROUP BY HoTen

-- 14. Hiển thị tên công ty và số lượng dự án của mỗi công ty.
SELECT TenCongTy,COUNT(*) AS SOLUONGDUAN
FROM CongTy
JOIN DuAn ON CongTy.MaCongTy = DuAn.MaCongTy
GROUP BY TenCongTy

-- 15. Tìm kỹ năng được sở hữu bởi nhiều chuyên gia nhất.
SELECT TenKyNang,COUNT(MaChuyenGia) AS SoChuyenGia
FROM KyNang
JOIN ChuyenGia_KyNang ON ChuyenGia_KyNang.MaKyNang = KyNang.MaKyNang
GROUP BY TenKyNang

-- 16. Liệt kê tên các chuyên gia có kỹ năng 'Python' với cấp độ từ 4 trở lên.
SELECT HoTen
FROM ChuyenGia
JOIN ChuyenGia_KyNang ON ChuyenGia_KyNang.MaChuyenGia = ChuyenGia.MaChuyenGia
JOIN KyNang ON KyNang.MaKyNang = ChuyenGia_KyNang.MaKyNang
WHERE TenKyNang = 'Python' AND CapDo >= 4

-- 17. Tìm dự án có nhiều chuyên gia tham gia nhất.
SELECT TenDuAn,COUNT(ChuyenGia_DuAn.MaChuyenGia) AS SOLUONGCHUYENGIA
FROM DuAn
JOIN ChuyenGia_DuAn ON ChuyenGia_DuAn.MaDuAn = DuAn.MaDuAn
JOIN ChuyenGia ON ChuyenGia.MaChuyenGia = ChuyenGia_DuAn.MaChuyenGia
GROUP BY TenDuAn

-- 18. Hiển thị tên và số lượng kỹ năng của mỗi chuyên gia.
SELECT HoTen,COUNT(KYNANG.MaKyNang) AS SOLUONGKYNANG
FROM ChuyenGia
JOIN ChuyenGia_KyNang ON ChuyenGia_KyNang.MaChuyenGia = ChuyenGia.MaChuyenGia
JOIN  KyNang ON KyNang.MaKyNang = ChuyenGia_KyNang.MaKyNang
GROUP BY HoTen

-- 19. Tìm các cặp chuyên gia làm việc cùng dự án.
SELECT A.MaChuyenGia AS MaChuyenGia1, B.MaChuyenGia AS MaChuyenGia2, A.MaDuAn
	FROM ChuyenGia_DuAn A
	JOIN ChuyenGia_DuAn B ON A.MaDuAn = B.MaDuAn
	WHERE A.MaChuyenGia < B.MaChuyenGia;

-- 20. Liệt kê tên các chuyên gia và số lượng kỹ năng cấp độ 5 của họ.
SELECT HoTen,COUNT(KYNANG.MaKyNang) AS SOLUONGKYNANG
FROM ChuyenGia
JOIN ChuyenGia_KyNang ON ChuyenGia_KyNang.MaChuyenGia = ChuyenGia.MaChuyenGia
JOIN  KyNang ON KyNang.MaKyNang = ChuyenGia_KyNang.MaKyNang
WHERE CAPDO = 5
GROUP BY HoTen

-- 21. Tìm các công ty không có dự án nào.
SELECT TenCongTy
FROM CongTy
LEFT JOIN DuAn ON DuAn.MaCongTy = CongTy.MaCongTy
WHERE MaDuAn IS NULL

-- 22. Hiển thị tên chuyên gia và tên dự án họ tham gia, bao gồm cả chuyên gia không tham gia dự án nào.
SELECT  HoTen,TenDuAn
FROM ChuyenGia
LEFT JOIN ChuyenGia_DuAn ON ChuyenGia.MaChuyenGia = ChuyenGia_DuAn.MaChuyenGia
LEFT JOIN DuAn ON DuAn.MaDuAn = ChuyenGia_DuAn.MaDuAn


-- 23. Tìm các chuyên gia có ít nhất 3 kỹ năng.
SELECT ChuyenGia.MaChuyenGia, ChuyenGia.HoTen, COUNT(ChuyenGia_KyNang.MaKyNang) AS SoLuongKyNang
FROM CHUYENGIA 
JOIN ChuyenGia_KyNang ON ChuyenGia.MaChuyenGia = ChuyenGia_KyNang.MaChuyenGia
GROUP BY ChuyenGia.MaChuyenGia, ChuyenGia.HoTen
HAVING COUNT(ChuyenGia_KyNang.MaKyNang) >= 3;

-- 24. Hiển thị tên công ty và tổng số năm kinh nghiệm của tất cả chuyên gia trong các dự án của công ty đó.
SELECT TenCongTy, SUM(NAMKINHNGHIEM) AS TongNamKinhNghiem
FROM CONGTY 
JOIN DUAN  ON CongTy.MaCongTy = DuAn.MaCongTy
JOIN ChuyenGia_DuAn ON DuAn.MaDuAn = ChuyenGia_DuAn.MaDuAn
JOIN CHUYENGIA  ON ChuyenGia_DuAn.MaChuyenGia = ChuyenGia.MaChuyenGia
GROUP BY CongTy.TenCongTy

-- 25. Tìm các chuyên gia có kỹ năng 'Java' nhưng không có kỹ năng 'Python'.
SELECT DISTINCT *
FROM ChuyenGia_KyNang
JOIN KyNang  ON ChuyenGia_KyNang.MaKyNang = KyNang.MaKyNang
WHERE KyNang.TenKyNang = 'Java'
  AND NOT EXISTS (
      SELECT 1 
      FROM KyNang 
      WHERE ChuyenGia_KyNang.MaKyNang = KyNang.MaKyNang
        AND KyNang.TenKyNang = 'Python'
  )

-- 76. Tìm chuyên gia có số lượng kỹ năng nhiều nhất.
SELECT TOP 1 ChuyenGia.MaChuyenGia, ChuyenGia.HoTen, COUNT(ChuyenGia_KyNang.MaKyNang) AS SoLuongKyNang
FROM CHUYENGIA 
JOIN ChuyenGia_KyNang ON ChuyenGia.MaChuyenGia = ChuyenGia_KyNang.MaChuyenGia
GROUP BY ChuyenGia.MaChuyenGia, ChuyenGia.HoTen
ORDER BY SoLuongKyNang DESC


-- 77. Liệt kê các cặp chuyên gia có cùng chuyên ngành.
SELECT cg1.MaChuyenGia AS ChuyenGia1, cg2.MaChuyenGia AS ChuyenGia2, cg1.ChuyenNganh
FROM ChuyenGia cg1
JOIN ChuyenGia cg2 ON cg1.ChuyenNganh = cg2.ChuyenNganh AND cg1.MaChuyenGia < cg2.MaChuyenGia;

-- 78. Tìm công ty có tổng số năm kinh nghiệm của các chuyên gia trong dự án cao nhất.
SELECT TOP 1 TenCongTy, SUM(NAMKINHNGHIEM) AS TongNamKinhNghiem
FROM CONGTY 
JOIN DUAN  ON CongTy.MaCongTy = DuAn.MaCongTy
JOIN ChuyenGia_DuAn ON DuAn.MaDuAn = ChuyenGia_DuAn.MaDuAn
JOIN CHUYENGIA  ON ChuyenGia_DuAn.MaChuyenGia = ChuyenGia.MaChuyenGia
GROUP BY CongTy.TenCongTy
ORDER BY TongNamKinhNghiem DESC

-- 79. Tìm kỹ năng được sở hữu bởi tất cả các chuyên gia.
SELECT TenKyNang
FROM  KyNang
JOIN ChuyenGia_KyNang ON ChuyenGia_KyNang.MaKyNang = KyNang.MaKyNang
GROUP BY TenKyNang
HAVING COUNT(DISTINCT ChuyenGia_KyNang.MaChuyenGia) = (SELECT COUNT(*) FROM ChuyenGia_KyNang);