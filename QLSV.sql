USE [QLSV]
GO
/****** Object:  Table [dbo].[DangNhap]    Script Date: 5/9/2018 10:48:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DangNhap](
	[TenDangNhap] [varchar](50) NOT NULL,
	[MatKhau] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KetQua]    Script Date: 5/9/2018 10:48:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KetQua](
	[SinhVienID] [char](3) NOT NULL,
	[MonHocID] [char](2) NOT NULL,
	[Diem] [float] NULL,
 CONSTRAINT [PK_KetQua] PRIMARY KEY CLUSTERED 
(
	[SinhVienID] ASC,
	[MonHocID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Khoa]    Script Date: 5/9/2018 10:48:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Khoa](
	[KhoaID] [char](2) NOT NULL,
	[TenKhoa] [nvarchar](50) NULL,
 CONSTRAINT [PK_Khoa] PRIMARY KEY CLUSTERED 
(
	[KhoaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MonHoc]    Script Date: 5/9/2018 10:48:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MonHoc](
	[MonHocID] [char](2) NOT NULL,
	[TenMon] [nvarchar](50) NULL,
 CONSTRAINT [PK_MonHoc] PRIMARY KEY CLUSTERED 
(
	[MonHocID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SinhVien]    Script Date: 5/9/2018 10:48:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SinhVien](
	[SinhVienID] [char](3) NOT NULL,
	[HoSinhVien] [nvarchar](30) NOT NULL,
	[TenSinhVien] [nvarchar](20) NOT NULL,
	[NgaySinh] [datetime] NULL,
	[GioiTinh] [bit] NOT NULL,
	[DiaChi] [nvarchar](50) NULL,
	[HocBong] [int] NULL,
	[KhoaID] [char](2) NULL,
 CONSTRAINT [PK_SinhVien] PRIMARY KEY CLUSTERED 
(
	[SinhVienID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[KetQua] ADD  CONSTRAINT [DF_KetQua_Diem]  DEFAULT ((0)) FOR [Diem]
GO
ALTER TABLE [dbo].[SinhVien] ADD  CONSTRAINT [DF_SinhVien_GioiTinh]  DEFAULT ((0)) FOR [GioiTinh]
GO
ALTER TABLE [dbo].[KetQua]  WITH CHECK ADD  CONSTRAINT [FK_KetQua_MonHoc] FOREIGN KEY([MonHocID])
REFERENCES [dbo].[MonHoc] ([MonHocID])
GO
ALTER TABLE [dbo].[KetQua] CHECK CONSTRAINT [FK_KetQua_MonHoc]
GO
ALTER TABLE [dbo].[KetQua]  WITH CHECK ADD  CONSTRAINT [FK_KetQua_SinhVien] FOREIGN KEY([SinhVienID])
REFERENCES [dbo].[SinhVien] ([SinhVienID])
GO
ALTER TABLE [dbo].[KetQua] CHECK CONSTRAINT [FK_KetQua_SinhVien]
GO
ALTER TABLE [dbo].[SinhVien]  WITH CHECK ADD  CONSTRAINT [FK_SinhVien_Khoa] FOREIGN KEY([KhoaID])
REFERENCES [dbo].[Khoa] ([KhoaID])
GO
ALTER TABLE [dbo].[SinhVien] CHECK CONSTRAINT [FK_SinhVien_Khoa]
GO
/****** Object:  StoredProcedure [dbo].[prGiaiMa]    Script Date: 5/9/2018 10:48:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[prGiaiMa] @encrypted_str VARBINARY(MAX), @chuoi NVARCHAR(100) OUTPUT
AS
BEGIN
 OPEN SYMMETRIC KEY SecureSymmetricKey
	DECRYPTION BY PASSWORD = '123456'

 DECLARE @temp_str VARBINARY(MAX)
 SET @temp_str = DecryptByKey(@encrypted_str);

 SET @chuoi = CONVERT(NVARCHAR(100), @temp_str)

 CLOSE SYMMETRIC KEY SecureSymmetricKey;
END
GO
/****** Object:  StoredProcedure [dbo].[prMaHoa]    Script Date: 5/9/2018 10:48:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[prMaHoa] @chuoi NVARCHAR(100),@encrypted_str VARBINARY(MAX) OUTPUT
AS
BEGIN
 OPEN SYMMETRIC KEY SecureSymmetricKey
	DECRYPTION BY PASSWORD = '123456'

 SET @encrypted_str = EncryptByKey(Key_GUID('SecureSymmetricKey'), @chuoi)

 CLOSE SYMMETRIC KEY SecureSymmetricKey;
END
GO
/****** Object:  StoredProcedure [dbo].[prThemND]    Script Date: 5/9/2018 10:48:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[prThemND] @madn NCHAR(20), @ten NVARCHAR(50),@matkhau NVARCHAR(30)
AS
BEGIN
 DECLARE @str VARBINARY(MAX)
 EXEC prMaHoa @matkhau,@str OUTPUT
 INSERT INTO NGUOIDUNG(madangnhap,hoten,matkhau)
 VALUES(@madn,@ten,@str)
END
GO
/****** Object:  StoredProcedure [dbo].[prXemND]    Script Date: 5/9/2018 10:48:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[prXemND] @madn NCHAR(20),@chuoi NVARCHAR(30) OUTPUT
AS
BEGIN
 DECLARE @matkhau VARBINARY(MAX)

 SELECT @matkhau=matkhau
 FROM NGUOIDUNG WHERE madangnhap=@madn

 EXEC prGiaiMa @matkhau, @chuoi OUTPUT
END
GO
/****** Object:  StoredProcedure [dbo].[sp_DemSoLuongSinhVien]    Script Date: 5/9/2018 10:48:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROC [dbo].[sp_DemSoLuongSinhVien]
AS
SELECT Count(*) FROM Sinhvien
GO
/****** Object:  StoredProcedure [dbo].[sp_DemSoLuongSinhVienTheoKhoa]    Script Date: 5/9/2018 10:48:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROC [dbo].[sp_DemSoLuongSinhVienTheoKhoa] @Makhoa int, @Dem int Output
AS
SELECT @Dem=Count(*) FROM Sinhvien Where khoaID=@Makhoa
GO
