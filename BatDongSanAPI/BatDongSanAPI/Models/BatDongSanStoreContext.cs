using System;
using MySql.Data.MySqlClient;
using BatDongSanAPI.Models;
using System.Collections.Generic;

namespace BatDongSanAPI.Models
{
    public class BatDongSanStoreContext
    {
        public string ConnectionString { get; set; }

        public BatDongSanStoreContext(string connectionString)
        {
            this.ConnectionString = connectionString;
        }

        private MySqlConnection GetConnection()
        {
            return new MySqlConnection(ConnectionString);
        }

        public String removeHopDong(string idHopDong)
        {
            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("DELETE from HopDong where idHopDong = '" + idHopDong + "' ", conn);
                cmd.ExecuteNonQuery();
            }

            return idHopDong;
        }

        public String removeDichVu(string idDichVu)
        {
            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("DELETE from DichVu where idDichVu = '" + idDichVu + "' ", conn);
                cmd.ExecuteNonQuery();
            }

            return idDichVu;
        }

        public String removePhong(string idPhong)
        {
            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("DELETE from Phong where idPhong = '" + idPhong + "' ", conn);
                cmd.ExecuteNonQuery();
            }

            return idPhong;
        }

        public String removeDonVi(string idDonVi)
        {
            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("DELETE from DonVi where idDonVi = '" + idDonVi + "' ", conn);
                cmd.ExecuteNonQuery();
            }

            return idDonVi;
        }

        public String removeNhaTro(string idNhaTro)
        {
            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("DELETE from NhaTro where idNhaTro = '" + idNhaTro + "' ", conn);
                cmd.ExecuteNonQuery();
            }

            return idNhaTro;
        }
        public String removeHoaDon(string idHoaDon)
        {
            using (MySqlConnection conn = GetConnection())
             {
                conn.Open();
                 MySqlCommand cmd = new MySqlCommand("DELETE from HoaDon where IdHoaDon = '" + idHoaDon + "' ", conn);
                 cmd.ExecuteNonQuery();
             }

            return idHoaDon;
        }

        public HoaDon AddListHoaDon(String IdPhong, String SoPhieu, String  NgayTao, String SoTien)
        {
            HoaDon hoadon = new HoaDon();
            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("INSERT INTO HoaDon (IdPhong,SoPhieu, NgayTao,SoTien ) VALUES('" + IdPhong + "', '" + SoPhieu + "', '" + NgayTao + "', '" + SoTien + "') ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM HoaDon ORDER BY IdHoaDon DESC LIMIT 1 ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        hoadon.IdHoaDon = reader["IdHoaDon"].ToString();
                        hoadon.IdPhong = reader["IdPhong"].ToString();
                        hoadon.SoPhieu = reader["SoPhieu"].ToString();
                        hoadon.NgayTao = reader["NgayTao"].ToString();
                        hoadon.SoTien = reader["SoTien"].ToString();
                    }
                }
            }

            return hoadon;
        }

        public String removePhieuThu(string idPhieuThu)
        {
            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("DELETE from PhieuThu where IdPhieuThu = '" + idPhieuThu + "' ", conn);
                cmd.ExecuteNonQuery();
            }

            return idPhieuThu;
        }

        public String removePhieuChi(string idPhieuChi)
        {
            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("DELETE from PhieuChi where IdPhieuChi = '" + idPhieuChi + "' ", conn);
                cmd.ExecuteNonQuery();
            }

            return idPhieuChi;
        }

        public String removeKhachHang(string idKhachHang)
        {
            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("DELETE from KhachHang where idKhachHang = '" + idKhachHang + "' ", conn);
                cmd.ExecuteNonQuery();
            }

            return idKhachHang;
        }

        public List<PhieuThu> GetListPhieuThu()
        {
            List<PhieuThu> list = new List<PhieuThu>();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("select * from PhieuThu", conn);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new PhieuThu()
                        {
                            IdPhieuThu = reader["IdPhieuThu"].ToString(),
                            IdPhong = reader["IdPhong"].ToString(),
                            IdHoaDon = reader["IdHoaDon"].ToString(),
                            Sotien = reader["SoTien"].ToString(),
                            Ngay = reader["Ngay"].ToString(),
                            GhiChu = reader["GhiChu"].ToString()
                        });
                    }
                }
            }
            return list;
        }

        public List<KhachHang> GetListKhachHang()
        {
            List<KhachHang> list = new List<KhachHang>();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("select * from KhachHang", conn);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new KhachHang()
                        {
                            idKhachHang = reader["idKhachHang"].ToString(),
                            TenKH = reader["TenKH"].ToString(),
                            IdPhong = reader["IdPhong"].ToString(),
                            NgaySinh = reader["NgaySinh"].ToString(),
                            GioiTinh = reader["GioiTinh"].ToString(),
                            SDT = reader["SDT"].ToString(),
                            Email = reader["Email"].ToString(),
                            CMND = reader["CMND"].ToString(),
                            Quequan = reader["Quequan"].ToString(),
                        });
                    }
                }
            }
            return list;
        }


        public HoaDon updateHoaDon(string IdHoaDon, string IdPhong, string SoPhieu, string NgayTao, string SoTien)
        {
            HoaDon hoadon = new HoaDon();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("UPDATE HoaDon SET IdPhong = '" + IdPhong + "', SoPhieu = '" + SoPhieu + "', NgayTao = '" + NgayTao + "', SoTien = '" + SoTien + "'  WHERE IdHoaDon = '" + IdHoaDon + "'  ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM HoaDon WHERE IdHoaDon = '" + IdHoaDon + "' ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        hoadon.IdHoaDon = reader["IdHoaDon"].ToString();
                        hoadon.IdPhong = reader["IdPhong"].ToString();
                        hoadon.SoPhieu = reader["SoPhieu"].ToString();
                        hoadon.NgayTao = reader["NgayTao"].ToString();
                        hoadon.SoTien = reader["SoTien"].ToString();
                    }
                }
            }

            return hoadon;
        }

        public PhieuThu addPhieuThu(string IdPhong, string IdHoaDon, string SoTien, string Ngay, string GhiChu)
        {
            PhieuThu phieuthu =  new PhieuThu() ;

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("INSERT INTO PhieuThu (IdPhong, IdHoaDon, SoTien, Ngay,GhiChu) VALUES('"+ IdPhong + "', '" + IdHoaDon + "', '" + SoTien + "', '" + Ngay + "', '" + GhiChu + "') ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM PhieuThu ORDER BY IdPhieuThu DESC LIMIT 1 ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        phieuthu.IdPhieuThu = reader["IdPhieuThu"].ToString();
                        phieuthu.IdPhong = reader["IdPhong"].ToString();
                        phieuthu.IdHoaDon = reader["IdHoaDon"].ToString();
                        phieuthu.Sotien = reader["SoTien"].ToString();
                        phieuthu.Ngay = reader["Ngay"].ToString();
                        phieuthu.GhiChu = reader["GhiChu"].ToString();
                    }
                }
            }

            return phieuthu;
        }

        public HopDong addHopDong(string ChuHopDong,string idPhong, string SoTienCoc,string NgayBD, string NgayKT,string GhiChu, string GioiTinh, string SDTKhachHang, string EmailKhachHang)
        {
            HopDong hopdong = new HopDong();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("INSERT INTO HopDong (ChuHopDong, idPhong, SoTienCoc, NgayBD,NgayKT, GhiChu, GioiTinh,SDTKhachHang, EmailKhachHang) VALUES('" + ChuHopDong + "', '" + idPhong + "', '" + SoTienCoc + "', '" + NgayBD + "', '" + NgayKT + "', '" + GhiChu + "', '" + GioiTinh + "', '" + SDTKhachHang + "', '" + EmailKhachHang + "') ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM HopDong ORDER BY idHopDong DESC LIMIT 1 ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        hopdong.idHopDong = reader["idHopDong"].ToString();
                        hopdong.ChuHopDong = reader["ChuHopDong"].ToString();
                        hopdong.idPhong = reader["idPhong"].ToString();
                        hopdong.SoTienCoc = reader["SoTienCoc"].ToString();
                        hopdong.NgayBD = reader["NgayBD"].ToString();
                        hopdong.NgayKT = reader["NgayKT"].ToString();
                        hopdong.GhiChu = reader["GhiChu"].ToString();
                        hopdong.GioiTinh = reader["GioiTinh"].ToString();
                        hopdong.SDTKhachHang = reader["SDTKhachHang"].ToString();
                        hopdong.EmailKhachHang = reader["EmailKhachHang"].ToString();
                    }
                }
            }

            return hopdong;
        }

        public Phong addPhong(string TenPhong, string DonGia, string SoDien,string SoNuoc, string IdNhaTro)
        {
            Phong phong = new Phong();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("INSERT INTO Phong (TenPhong, DonGia, SoDien, SoNuoc,IdNhaTro) VALUES('" + TenPhong + "', '" + DonGia + "', '" + SoDien + "', '" + SoNuoc + "', '" + IdNhaTro + "') ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM Phong ORDER BY idPhong DESC LIMIT 1 ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        phong.TenPhong = reader["TenPhong"].ToString();
                        phong.DonGia = reader["DonGia"].ToString();
                        phong.SoDien = reader["SoDien"].ToString();
                        phong.SoNuoc = reader["SoNuoc"].ToString();
                        phong.IdNhaTro = reader["IdNhaTro"].ToString();
                    }
                }
            }

            return phong;
        }

        public DichVu addDichvu(string TenDichVu, string DonGia, string idDonvi, string MacDinh)
        {
            DichVu phong = new DichVu();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("INSERT INTO DichVu (TenDichVu, DonGia, idDonvi, MacDinh) VALUES('" + TenDichVu + "', '" + DonGia + "', '" + idDonvi + "', '" + MacDinh + "') ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM DichVu ORDER BY idDichVu DESC LIMIT 1 ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        phong.TenDichVu = reader["TenDichVu"].ToString();
                        phong.DonGia = reader["DonGia"].ToString();
                        phong.idDonvi = reader["idDonvi"].ToString();
                        phong.MacDinh = reader["MacDinh"].ToString();
                    }
                }
            }

            return phong;
        }


        public DonVi addDonVi(string TenDonVi, string GhiChu)
        {
            DonVi donvi = new DonVi();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("INSERT INTO DonVi (TenDonVi, GhiChu) VALUES('" + TenDonVi + "', '" + GhiChu + "') ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM DonVi ORDER BY idDonVi DESC LIMIT 1 ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        donvi.TenDonVi = reader["TenDonVi"].ToString();
                        donvi.GhiChu = reader["GhiChu"].ToString();
                    }
                }
            }

            return donvi;
        }

        public NhaTro addNhaTro(string TenNhaTro, string GhiChu)
        {
            NhaTro nhatro = new NhaTro();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("INSERT INTO NhaTro (TenNhaTro, GhiChu) VALUES('" + TenNhaTro + "', '" + GhiChu + "') ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM NhaTro ORDER BY idNhaTro DESC LIMIT 1 ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        nhatro.TenNhaTro = reader["TenNhaTro"].ToString();
                        nhatro.GhiChu = reader["GhiChu"].ToString();
                    }
                }
            }

            return nhatro;
        }

        public KhachHang addKhachHang( string TenKH, string IdPhong, string NgaySinh, string GioiTinh, string SDT, string Email, string CMND, string Quequan)
        {
                KhachHang khachhang = new KhachHang();

                using (MySqlConnection conn = GetConnection())
                {
                    conn.Open();
                MySqlCommand cmd = new MySqlCommand("INSERT INTO KhachHang (TenKH, IdPhong, NgaySinh, GioiTinh, SDT, Email, CMND, Quequan) VALUES('" + TenKH + "', '" + IdPhong + "', '" + NgaySinh + "', '" + GioiTinh + "','" + SDT + "','" + Email + "','" + CMND + "','" + Quequan + "' ) ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM KhachHang ORDER BY idKhachHang DESC LIMIT 1 ";

                using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            khachhang.idKhachHang = reader["idKhachHang"].ToString();
                            khachhang.IdPhong = reader["IdPhong"].ToString();
                            khachhang.TenKH = reader["TenKH"].ToString();
                            khachhang.NgaySinh = reader["NgaySinh"].ToString();
                            khachhang.GioiTinh = reader["GioiTinh"].ToString();
                            khachhang.SDT = reader["SDT"].ToString();
                            khachhang.Email = reader["Email"].ToString();
                            khachhang.CMND = reader["CMND"].ToString();
                            khachhang.Quequan = reader["Quequan"].ToString();
                        }
                    }
                }

                return khachhang;

        }

        public PhieuChi addPhieuChi(string IdPhong, string SoTien, string Ngay, string DienGiai)
        {
            PhieuChi phieuchi = new PhieuChi();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("INSERT INTO PhieuChi (IdPhong, Sotien, Ngay, DienGiai) VALUES('" + IdPhong + "', '" + SoTien + "', '" + Ngay + "', '" + DienGiai + "') ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM PhieuChi ORDER BY IdPhieuChi DESC LIMIT 1 ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        phieuchi.IdPhieuChi = reader["IdPhieuChi"].ToString();
                        phieuchi.IdPhong = reader["IdPhong"].ToString();
                        phieuchi.Sotien = reader["SoTien"].ToString();
                        phieuchi.Ngay = reader["Ngay"].ToString();
                        phieuchi.DienGiai = reader["DienGiai"].ToString();
                    }
                }
            }

            return phieuchi;
        }

        public PhieuChi updatePhieuChi(string IdPhieuChi, string IdPhong, string SoTien, string Ngay, string DienGiai)
        {
            PhieuChi phieuchi = new PhieuChi();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("UPDATE PhieuChi SET Sotien = '"+ SoTien+ "' , Ngay = '"+ Ngay + "', DienGiai = '"+DienGiai+ "' WHERE IdPhieuChi = '"+ IdPhieuChi+"'    ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM PhieuChi WHERE IdPhieuChi = '"+ IdPhieuChi + "' ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        phieuchi.IdPhieuChi = reader["IdPhieuChi"].ToString();
                        phieuchi.IdPhong = reader["IdPhong"].ToString();
                        phieuchi.Sotien = reader["Sotien"].ToString();
                        phieuchi.Ngay = reader["Ngay"].ToString();
                        phieuchi.DienGiai = reader["DienGiai"].ToString();
                    }
                }
            }

            return phieuchi;
        }

        public Phong updatePhong(string idPhong, string TenPhong, string DonGia, string SoDien, string SoNuoc, string IdNhaTro)
        {
            Phong phong = new Phong();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("UPDATE Phong SET TenPhong = '" + TenPhong + "' , DonGia = '" + DonGia + "', SoDien = '" + SoDien + "', SoNuoc = '" + SoNuoc + "', IdNhaTro = '" + IdNhaTro + "' WHERE idPhong = '" + idPhong + "' ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM Phong WHERE idPhong = '" + idPhong + "' ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        phong.idPhong = reader["idPhong"].ToString();
                        phong.TenPhong = reader["TenPhong"].ToString();
                        phong.DonGia = reader["DonGia"].ToString();
                        phong.SoDien = reader["SoDien"].ToString();
                        phong.SoNuoc = reader["SoNuoc"].ToString();
                        phong.IdNhaTro = reader["IdNhaTro"].ToString();
                    }
                }
            }

            return phong;
        }

        public DichVu updateDichVu(string idDichVu, string TenDichVu, string DonGia, string idDonvi, string MacDinh)
        {
            DichVu dichvu = new DichVu();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("UPDATE DichVu SET TenDichVu = '" + TenDichVu + "' , DonGia = '" + DonGia + "', idDonvi = '" + idDonvi + "', MacDinh = '" + MacDinh + "'WHERE idDichVu = '" + idDichVu + "' ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM DichVu WHERE idDichVu = '" + idDichVu + "' ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        dichvu.idDichVu = reader["idDichVu"].ToString();
                        dichvu.TenDichVu = reader["TenDichVu"].ToString();
                        dichvu.DonGia = reader["DonGia"].ToString();
                        dichvu.idDonvi = reader["idDonvi"].ToString();
                        dichvu.MacDinh = reader["MacDinh"].ToString();
                    }
                }
            }

            return dichvu;
        }

        public DonVi updateDonVi(string idDonVi, string TenDonVi, string GhiChu)
        {
            DonVi donvi = new DonVi();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("UPDATE DonVi SET TenDonVi = '" + TenDonVi + "' , GhiChu = '" + GhiChu + "' WHERE idDonVi = '" + idDonVi + "' ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM DonVi WHERE idDonVi = '" + idDonVi + "' ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        donvi.idDonVi = reader["idDonVi"].ToString();
                        donvi.TenDonVi = reader["TenDonVi"].ToString();
                        donvi.GhiChu = reader["GhiChu"].ToString();
                    }
                }
            }

            return donvi;
        }
        public NhaTro updateNhaTro(string idNhaTro, string TenNhaTro, string GhiChu)
        {
            NhaTro nhatro = new NhaTro();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("UPDATE NhaTro SET TenNhaTro = '" + TenNhaTro + "' , GhiChu = '" + GhiChu + "' WHERE idNhaTro = '" + idNhaTro + "' ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM NhaTro WHERE idNhaTro = '" + idNhaTro + "' ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        nhatro.idNhaTro = reader["idNhaTro"].ToString();
                        nhatro.TenNhaTro = reader["TenNhaTro"].ToString();
                        nhatro.GhiChu = reader["GhiChu"].ToString();
                    }
                }
            }

            return nhatro;
        }

        public HopDong updateHopDong(string IdHopDong,string ChuHopDong, string idPhong, string SoTienCoc, string NgayBD, string NgayKT, string GhiChu, string GioiTinh, string SDTKhachHang, string EmailKhachHang)
        {
            HopDong hopdong = new HopDong();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("UPDATE HopDong SET ChuHopDong = '" + ChuHopDong + "' , idPhong = '" + idPhong + "', SoTienCoc = '" + SoTienCoc + "', NgayBD = '" + NgayBD + "', NgayKT = '" + NgayKT + "', GhiChu = '" + GhiChu + "', GioiTinh = '" + GioiTinh + "', SDTKhachHang = '" + SDTKhachHang + "', EmailKhachHang = '" + EmailKhachHang + "'  WHERE idHopDong = '" + IdHopDong + "' ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM HopDong WHERE IdHopDong = '" + IdHopDong + "' ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        hopdong.idHopDong = reader["idHopDong"].ToString();
                        hopdong.ChuHopDong = reader["ChuHopDong"].ToString();
                        hopdong.idPhong = reader["idPhong"].ToString();
                        hopdong.SoTienCoc = reader["SoTienCoc"].ToString();
                        hopdong.NgayBD = reader["NgayBD"].ToString();
                        hopdong.NgayKT = reader["NgayKT"].ToString();
                        hopdong.GhiChu = reader["GhiChu"].ToString();
                        hopdong.GioiTinh = reader["GioiTinh"].ToString();
                        hopdong.SDTKhachHang = reader["SDTKhachHang"].ToString();
                        hopdong.EmailKhachHang = reader["EmailKhachHang"].ToString();
                    }
                }
            }

            return hopdong;
        }


        public KhachHang updateKhachHang(string idKhachHang, string TenKH, string IdPhong, string NgaySinh, string GioiTinh, string SDT, string Email, string CMND, string Quequan)
        {
            KhachHang khachhang = new KhachHang();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("UPDATE KhachHang SET TenKH = '" + TenKH + "' , IdPhong = '" + IdPhong + "', NgaySinh = '" + NgaySinh + "', GioiTinh = '"+ GioiTinh + "', SDT = '" + SDT + "', Email = '" + Email + "', CMND = '" + CMND + "', Quequan = '" + Quequan + "'  WHERE idKhachHang = '" + idKhachHang + "'    ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM KhachHang WHERE idKhachHang = '" + idKhachHang + "' ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        khachhang.idKhachHang = reader["idKhachHang"].ToString();
                        khachhang.IdPhong = reader["IdPhong"].ToString();
                        khachhang.TenKH = reader["TenKH"].ToString();
                        khachhang.NgaySinh = reader["NgaySinh"].ToString();
                        khachhang.GioiTinh = reader["GioiTinh"].ToString();
                        khachhang.SDT = reader["SDT"].ToString();
                        khachhang.Email = reader["Email"].ToString();
                        khachhang.CMND = reader["CMND"].ToString();
                        khachhang.Quequan = reader["Quequan"].ToString();
                    }
                }
            }

            return khachhang;
        }

        public List<HoaDon> GetListHoaDon()
        {
            List<HoaDon> list = new List<HoaDon>();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("select * from HoaDon", conn);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new HoaDon()
                        {
                            IdHoaDon = reader["IdHoaDon"].ToString(),
                            IdPhong = reader["IdPhong"].ToString(),
                            SoPhieu = reader["SoPhieu"].ToString(),
                            NgayTao = reader["NgayTao"].ToString(),
                            SoTien = reader["SoTien"].ToString(),
                            DaTra = reader["DaTra"].ToString()
                        });
                    }
                }
            }
            return list;
        }

        public List<DichVu> GetListDichVu()
        {
            List<DichVu> list = new List<DichVu>();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("select * from DichVu", conn);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new DichVu()
                        {
                            idDichVu = reader["idDichVu"].ToString(),
                            TenDichVu = reader["TenDichVu"].ToString(),
                            DonGia = reader["DonGia"].ToString(),
                            idDonvi = reader["idDonvi"].ToString(),
                            MacDinh = reader["MacDinh"].ToString()
                        });
                    }
                }
            }
            return list;
        }

        public List<DonVi> GetListDonVi()
        {
            List<DonVi> list = new List<DonVi>();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("select * from DonVi", conn);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new DonVi()
                        {
                            idDonVi = reader["idDonVi"].ToString(),
                            TenDonVi = reader["TenDonVi"].ToString(),
                            GhiChu = reader["GhiChu"].ToString()
                        });
                    }
                }
            }
            return list;
        }

        public List<PhieuChi> GetListPhieuChi()
        {
            List<PhieuChi> list = new List<PhieuChi>();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("select * from PhieuChi", conn);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new PhieuChi()
                        {
                            IdPhieuChi = reader["IdPhieuChi"].ToString(),
                            IdPhong = reader["IdPhong"].ToString(),
                            Sotien = reader["Sotien"].ToString(),
                            Ngay = reader["Ngay"].ToString(),
                            DienGiai = reader["DienGiai"].ToString()
                        });
                    }
                }
            }
            return list;
        }

        public List<HoaDon_Phong> getListHoaDon_Phong () {
            List<HoaDon_Phong> list = new List<HoaDon_Phong>();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("SELECT * FROM HoaDon AS T1 INNER JOIN Phong AS T2 ON T1.IdPhong = T2.idPhong; ", conn);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new HoaDon_Phong()
                        {
                            IdHoaDon = reader["IdHoaDon"].ToString(),
                            IdPhong = reader["IdPhong"].ToString(),
                            SoPhieu = reader["SoPhieu"].ToString(),
                            NgayTao = reader["NgayTao"].ToString(),
                            SoTien = reader["SoTien"].ToString(),
                            DaTra = reader["DaTra"].ToString(),
                            TenPhong = reader["TenPhong"].ToString(),
                            DonGia = reader["DonGia"].ToString(),
                            SoDien = reader["SoDien"].ToString(),
                            SoNuoc = reader["SoNuoc"].ToString()


                        });
                    }
                }
            }
            return list;
        }

        public List<Phong> GetListPhong()
        {
            List<Phong> list = new List<Phong>();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("select * from Phong ", conn);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new Phong()
                        {
                            idPhong = reader["idPhong"].ToString(),
                            TenPhong = reader["TenPhong"].ToString(),
                            DonGia = reader["DonGia"].ToString(),
                            SoDien = reader["SoDien"].ToString(),
                            SoNuoc = reader["SoNuoc"].ToString(),
                            IdNhaTro = reader["IdNhaTro"].ToString()
                        });
                    }
                }
            }
            return list;
        }

        public List<Account> GetInformationAccount(string email, string password)
        {
            List<Account> list = new List<Account>();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("select * from Account where Email = '" + email + "' AND MatKhau = '" + password + "' ", conn);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new Account()
                        {
                            IdNhaTro = Convert.ToInt32(reader["idNhaTro"]),
                            Email = reader["Email"].ToString(),
                            MatKhau = reader["MatKhau"].ToString(),
                            Hoten = reader["HoTen"].ToString(),
                            Gioitinh = Convert.ToBoolean(reader["GioiTinh"]),
                            NamSinh = Convert.ToInt32(reader["NamSinh"]),
                            Sdt = reader["SDT"].ToString(),
                            DiaChi = reader["DiaChi"].ToString(),
                            AnhDaiDien = reader["AnhDaiDien"].ToString()
                        });
                    }
                }
            }
            return list;
        }

        public List<HopDong> GetListHopDong() {
            List<HopDong> list = new List<HopDong>();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("select * from HopDong", conn);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new HopDong()
                        {
                            idHopDong = reader["idHopDong"].ToString(),
                            ChuHopDong = reader["ChuHopDong"].ToString(),
                            idPhong = reader["idPhong"].ToString(),
                            SoTienCoc = reader["SoTienCoc"].ToString(),
                            NgayBD = reader["NgayBD"].ToString(),
                            NgayKT = reader["NgayKT"].ToString(),
                            GhiChu = reader["GhiChu"].ToString(),
                            GioiTinh = reader["GioiTinh"].ToString(),
                            SDTKhachHang = reader["SDTKhachHang"].ToString(),
                            EmailKhachHang = reader["EmailKhachHang"].ToString()
                        });
                    }
                }
            }
            return list;
        }

        public List<NhaTro> GetListNhaTro()
        {
            List<NhaTro> list = new List<NhaTro>();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("select * from NhaTro", conn);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new NhaTro()
                        {
                            idNhaTro = reader["idNhaTro"].ToString(),
                            TenNhaTro = reader["TenNhaTro"].ToString(),
                            GhiChu = reader["GhiChu"].ToString()
                        });
                    }
                }
            }
            return list;
        }

    }
}
