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

        public String removeCanHo(string idCanHo)
        {
            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("DELETE from CanHo where idCanHo = '" + idCanHo + "' ", conn);
                cmd.ExecuteNonQuery();
            }

            return idCanHo;
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

        public HoaDon AddListHoaDon(String IdCanHo, String SoPhieu, String  NgayTao, String SoTien)
        {
            HoaDon hoadon = new HoaDon();
            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("INSERT INTO HoaDon (IdCanHo,SoPhieu, NgayTao,SoTien ) VALUES('" + IdCanHo + "', '" + SoPhieu + "', '" + NgayTao + "', '" + SoTien + "') ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM HoaDon ORDER BY IdHoaDon DESC LIMIT 1 ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        hoadon.IdHoaDon = reader["IdHoaDon"].ToString();
                        hoadon.IdCanHo = reader["IdCanHo"].ToString();
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
                            IdCanHo = reader["IdCanHo"].ToString(),
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
                            IdKhachHang = reader["IdKhachHang"].ToString(),
                            TenKH = reader["TenKH"].ToString(),
                            IdCanHo = reader["IdCanHo"].ToString(),
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


        public HoaDon updateHoaDon(string IdHoaDon, string IdCanHo, string SoPhieu, string NgayTao, string SoTien)
        {
            HoaDon hoadon = new HoaDon();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("UPDATE HoaDon SET IdCanHo = '" + IdCanHo + "', SoPhieu = '" + SoPhieu + "', NgayTao = '" + NgayTao + "', SoTien = '" + SoTien + "'  WHERE IdHoaDon = '" + IdHoaDon + "'  ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM HoaDon WHERE IdHoaDon = '" + IdHoaDon + "' ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        hoadon.IdHoaDon = reader["IdHoaDon"].ToString();
                        hoadon.IdCanHo = reader["IdCanHo"].ToString();
                        hoadon.SoPhieu = reader["SoPhieu"].ToString();
                        hoadon.NgayTao = reader["NgayTao"].ToString();
                        hoadon.SoTien = reader["SoTien"].ToString();
                        hoadon.SoDienMoi = reader["SoDienMoi"].ToString();
                        hoadon.SoNuocMoi = reader["SoNuocMoi"].ToString();
                    }
                }
            }

            return hoadon;
        }

        public PhieuThu addPhieuThu(string IdCanHo, string IdHoaDon, string SoTien, string Ngay, string GhiChu)
        {
            PhieuThu phieuthu =  new PhieuThu() ;

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("INSERT INTO PhieuThu (IdCanHo, IdHoaDon, SoTien, Ngay,GhiChu) VALUES('"+ IdCanHo + "', '" + IdHoaDon + "', '" + SoTien + "', '" + Ngay + "', '" + GhiChu + "') ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM PhieuThu ORDER BY IdPhieuThu DESC LIMIT 1 ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        phieuthu.IdPhieuThu = reader["IdPhieuThu"].ToString();
                        phieuthu.IdCanHo = reader["IdCanHo"].ToString();
                        phieuthu.IdHoaDon = reader["IdHoaDon"].ToString();
                        phieuthu.Sotien = reader["SoTien"].ToString();
                        phieuthu.Ngay = reader["Ngay"].ToString();
                        phieuthu.GhiChu = reader["GhiChu"].ToString();
                    }
                }
            }

            return phieuthu;
        }


        public HopDong addHopDong(string ChuHopDong,string idCanHo, string SoTienCoc,string NgayBD, string NgayKT,string GhiChu, string GioiTinh, string SDTKhachHang, string EmailKhachHang)
        {
            HopDong hopdong = new HopDong();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("INSERT INTO HopDong (ChuHopDong, idCanHo, SoTienCoc, NgayBD,NgayKT, GhiChu, GioiTinh,SDTKhachHang, EmailKhachHang) VALUES('" + ChuHopDong + "', '" + idCanHo + "', '" + SoTienCoc + "', '" + NgayBD + "', '" + NgayKT + "', '" + GhiChu + "', '" + GioiTinh + "', '" + SDTKhachHang + "', '" + EmailKhachHang + "') ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM HopDong ORDER BY idHopDong DESC LIMIT 1 ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        hopdong.IdHopDong = reader["IdHopDong"].ToString();
                        hopdong.ChuHopDong = reader["ChuHopDong"].ToString();
                        hopdong.IdCanHo = reader["IdCanHo"].ToString();
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

        public CanHo addCanHo( string TenCanHo, string DonGia,  string SoDienCu,  string SoNuocCu, string DienTich, string DiaChi)
        {
            CanHo phong = new CanHo();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("INSERT INTO CanHo (TenCanHo, DonGia, SoDienCu, SoNuocCu,DienTich, DiaChi) VALUES('" + TenCanHo + "', '" + DonGia + "', '" + SoDienCu + "', '" + SoNuocCu + "', '" + DienTich + "', '"+ DiaChi + "') ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM CanHo ORDER BY IdCanHo DESC LIMIT 1 ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        phong.IdCanHo = reader["IdCanHo"].ToString();
                        phong.TenCanHo = reader["TenCanHo"].ToString();
                        phong.DonGia = reader["DonGia"].ToString();
                        phong.SoDienCu = reader["SoDienCu"].ToString();
                        phong.SoNuocCu = reader["SoNuocCu"].ToString();
                        phong.DienTich = reader["DienTich"].ToString();
                        phong.DiaChi = reader["DiaChi"].ToString();
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

        public KhachHang addKhachHang( string TenKH, string IdCanHo, string NgaySinh, string GioiTinh, string SDT, string Email, string CMND, string Quequan)
        {
                KhachHang khachhang = new KhachHang();

                using (MySqlConnection conn = GetConnection())
                {
                    conn.Open();
                MySqlCommand cmd = new MySqlCommand("INSERT INTO KhachHang (TenKH, IdCanHo, NgaySinh, GioiTinh, SDT, Email, CMND, Quequan) VALUES('" + TenKH + "', '" + IdCanHo + "', '" + NgaySinh + "', '" + GioiTinh + "','" + SDT + "','" + Email + "','" + CMND + "','" + Quequan + "' ) ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM KhachHang ORDER BY idKhachHang DESC LIMIT 1 ";

                using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            khachhang.IdKhachHang = reader["IdKhachHang"].ToString();
                            khachhang.IdCanHo = reader["IdCanHo"].ToString();
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

        public PhieuChi addPhieuChi(string IdCanHo, string SoTien, string Ngay, string DienGiai)
        {
            PhieuChi phieuchi = new PhieuChi();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("INSERT INTO PhieuChi (IdCanHo, Sotien, Ngay, DienGiai) VALUES('" + IdCanHo + "', '" + SoTien + "', '" + Ngay + "', '" + DienGiai + "') ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM PhieuChi ORDER BY IdPhieuChi DESC LIMIT 1 ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        phieuchi.IdPhieuChi = reader["IdPhieuChi"].ToString();
                        phieuchi.IdCanHo = reader["IdCanHo"].ToString();
                        phieuchi.Sotien = reader["SoTien"].ToString();
                        phieuchi.Ngay = reader["Ngay"].ToString();
                        phieuchi.DienGiai = reader["DienGiai"].ToString();
                    }
                }
            }

            return phieuchi;
        }

        public PhieuChi updatePhieuChi(string IdPhieuChi, string IdCanHo, string SoTien, string Ngay, string DienGiai)
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
                        phieuchi.IdCanHo = reader["IdCanHo"].ToString();
                        phieuchi.Sotien = reader["Sotien"].ToString();
                        phieuchi.Ngay = reader["Ngay"].ToString();
                        phieuchi.DienGiai = reader["DienGiai"].ToString();
                    }
                }
            }

            return phieuchi;
        }

        public Account updateAccount(string IdAccount, string HoTen, string GioiTinh, string NamSinh, string SDT, string DiaChi)
        {
            Account account = new Account();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("UPDATE Account SET HoTen = '" + HoTen + "' , GioiTinh = '" + GioiTinh + "', NamSinh = '" + NamSinh + "', SDT = '" + SDT + "', DiaChi = '" + DiaChi + "' WHERE IdAccount = '" + IdAccount + "'    ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM Account WHERE IdAccount = '" + IdAccount + "' ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        account.IdAccount = reader["IdAccount"].ToString();
                        account.Email = reader["Email"].ToString();
                        account.MatKhau = reader["MatKhau"].ToString();
                        account.Hoten = reader["Hoten"].ToString();
                        account.Gioitinh = reader["Gioitinh"].ToString();
                        account.NamSinh = reader["NamSinh"].ToString();
                        account.Sdt = reader["SDT"].ToString();
                        account.DiaChi = reader["DiaChi"].ToString();
                    }
                }
            }

            return account;
        }

        public CanHo updateCanHo( string IdCanHo, string TenCanHo, string DonGia, string SoDienCu, string SoNuocCu, string DienTich, string DiaChi)
        {
            CanHo phong = new CanHo();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("UPDATE CanHo SET TenCanHo = '" + TenCanHo + "' , DonGia = '" + DonGia + "', SoDienCu = '" + SoDienCu + "', SoNuocCu = '" + SoNuocCu + "', DienTich = '" + DienTich + "', DiaChi = '"+ DiaChi + "' WHERE IdCanHo = '" + IdCanHo + "' ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM CanHo WHERE IdCanHo = '" + IdCanHo + "' ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        phong.IdCanHo = reader["IdCanHo"].ToString();
                        phong.TenCanHo = reader["TenCanHo"].ToString();
                        phong.DonGia = reader["DonGia"].ToString();
                        phong.SoDienCu = reader["SoDienCu"].ToString();
                        phong.SoNuocCu = reader["SoNuocCu"].ToString();
                        phong.DienTich = reader["DienTich"].ToString();
                        phong.DiaChi = reader["DiaChi"].ToString();
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

        public HopDong updateHopDong(string IdHopDong,string ChuHopDong, string idCanHo, string SoTienCoc, string NgayBD, string NgayKT, string GhiChu, string GioiTinh, string SDTKhachHang, string EmailKhachHang)
        {
            HopDong hopdong = new HopDong();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("UPDATE HopDong SET ChuHopDong = '" + ChuHopDong + "' , idCanHo = '" + idCanHo + "', SoTienCoc = '" + SoTienCoc + "', NgayBD = '" + NgayBD + "', NgayKT = '" + NgayKT + "', GhiChu = '" + GhiChu + "', GioiTinh = '" + GioiTinh + "', SDTKhachHang = '" + SDTKhachHang + "', EmailKhachHang = '" + EmailKhachHang + "'  WHERE idHopDong = '" + IdHopDong + "' ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM HopDong WHERE IdHopDong = '" + IdHopDong + "' ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        hopdong.IdHopDong = reader["IdHopDong"].ToString();
                        hopdong.ChuHopDong = reader["ChuHopDong"].ToString();
                        hopdong.IdCanHo = reader["IdCanHo"].ToString();
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


        public KhachHang updateKhachHang(string idKhachHang, string TenKH, string IdCanHo, string NgaySinh, string GioiTinh, string SDT, string Email, string CMND, string Quequan)
        {
            KhachHang khachhang = new KhachHang();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("UPDATE KhachHang SET TenKH = '" + TenKH + "' , IdCanHo = '" + IdCanHo + "', NgaySinh = '" + NgaySinh + "', GioiTinh = '"+ GioiTinh + "', SDT = '" + SDT + "', Email = '" + Email + "', CMND = '" + CMND + "', Quequan = '" + Quequan + "'  WHERE idKhachHang = '" + idKhachHang + "'    ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM KhachHang WHERE idKhachHang = '" + idKhachHang + "' ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        khachhang.IdKhachHang = reader["IdKhachHang"].ToString();
                        khachhang.IdCanHo = reader["IdCanHo"].ToString();
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
                            IdCanHo = reader["IdCanHo"].ToString(),
                            SoPhieu = reader["SoPhieu"].ToString(),
                            NgayTao = reader["NgayTao"].ToString(),
                            SoTien = reader["SoTien"].ToString(),
                            DaTra = reader["DaTra"].ToString(),
                            SoDienMoi = reader["SoDienMoi"].ToString(),
                            SoNuocMoi = reader["SoNuocMoi"].ToString()
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
                            IdCanHo = reader["IdCanHo"].ToString(),
                            Sotien = reader["Sotien"].ToString(),
                            Ngay = reader["Ngay"].ToString(),
                            DienGiai = reader["DienGiai"].ToString()
                        });
                    }
                }
            }
            return list;
        }

        public List<HoaDon_CanHo> getListHoaDon_CanHo () {
            List<HoaDon_CanHo> list = new List<HoaDon_CanHo>();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("SELECT * FROM HoaDon AS T1 INNER JOIN CanHo AS T2 ON T1.IdCanHo = T2.IdCanHo ", conn);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new HoaDon_CanHo()
                        {

                            IdPhieuThu = reader["IdPhieuThu"].ToString(),
                            IdHoaDon = reader["IdHoaDon"].ToString(),
                            IdCanHo = reader["IdCanHo"].ToString(),
                            SoPhieu = reader["SoPhieu"].ToString(),
                            NgayTao = reader["NgayTao"].ToString(),
                            SoTien = reader["SoTien"].ToString(),
                            DaTra = reader["DaTra"].ToString(),
                            TenCanHo = reader["TenCanHo"].ToString(),
                            DonGia = reader["DonGia"].ToString(),

                            SoDien = reader["SoDienCu"].ToString(),
                            SoNuoc = reader["SoNuocCu"].ToString(),
                            SoDienMoi = reader["SoDienMoi"].ToString(),
                            SoNuocMoi = reader["SoNuocMoi"].ToString(),
                            DienTich = reader["DienTich"].ToString(),
                            DiaChi = reader["DiaChi"].ToString()
                        });
                    }
                }
            }
            return list;
        }

        public List<CanHo> GetListCanHo()
        {
            List<CanHo> list = new List<CanHo>();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("select * from CanHo ", conn);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new CanHo()
                        {
                            IdCanHo = reader["IdCanHo"].ToString(),
                            TenCanHo = reader["TenCanHo"].ToString(),
                            DonGia = reader["DonGia"].ToString(),
                            SoDienCu = reader["SoDienCu"].ToString(),
                            SoNuocCu = reader["SoNuocCu"].ToString(),
                            DienTich = reader["DienTich"].ToString(),
                            DiaChi = reader["DiaChi"].ToString()
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
                            IdAccount = reader["IdAccount"].ToString(),
                            Email = reader["Email"].ToString(),
                            MatKhau = reader["MatKhau"].ToString(),
                            Hoten = reader["HoTen"].ToString(),
                            Gioitinh = reader["GioiTinh"].ToString(),
                            NamSinh = reader["NamSinh"].ToString(),
                            Sdt = reader["SDT"].ToString(),
                            DiaChi = reader["DiaChi"].ToString(),
                            AnhDaiDien = reader["AnhDaiDien"].ToString()
                        });
                    }
                }
            }
            return list;
        }

        public String UpdateHoaDon_PhieuThu( string IdHoaDon,  string IdPhieuThu) {
            PhieuThu phieuthu = new PhieuThu();

                using (MySqlConnection conn = GetConnection())
                {
                    conn.Open();
                    MySqlCommand cmd = new MySqlCommand("UPDATE HoaDon SET IdPhieuThu = '" + IdPhieuThu + "'  WHERE IdHoaDon = '" + IdHoaDon + "'  ", conn);
                    cmd.ExecuteNonQuery();

                return IdHoaDon;
                }
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
                            IdHopDong = reader["IdHopDong"].ToString(),
                            ChuHopDong = reader["ChuHopDong"].ToString(),
                            IdCanHo = reader["IdCanHo"].ToString(),
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
