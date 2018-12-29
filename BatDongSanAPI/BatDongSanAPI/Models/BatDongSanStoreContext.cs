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


        public String removeDichVu(string IdDichVu)
        {
            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("DELETE from DichVu where IdDichVu = '" + IdDichVu + "' ", conn);
                cmd.ExecuteNonQuery();
            }

            return IdDichVu;
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

        public HoaDon AddListHoaDon(String IdCanHo, String SoPhieu, String  NgayTao, String SoTien, string SoDienMoi,  string SoNuocMoi)
        {
            HoaDon hoadon = new HoaDon();
            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("INSERT INTO HoaDon (IdCanHo,SoPhieu, NgayTao,SoTien,SoDienMoi,SoNuocMoi ) VALUES('" + IdCanHo + "', '" + SoPhieu + "', '" + NgayTao + "', '" + SoTien + "', '" + SoDienMoi + "', '" + SoNuocMoi + "') ", conn);
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
                        hoadon.SoDienMoi = reader["SoDienMoi"].ToString();
                        hoadon.SoNuocMoi = reader["SoNuocMoi"].ToString();
                        hoadon.IdPhieuThu = reader["IdPhieuThu"].ToString();
                    }
                }
            }

            return hoadon;
        }

        public CanHo_DichVu AddOrUpDateListCanHo_DichVu(String IdDichVu, String IdCanHo)
        {
            CanHo_DichVu canHo_DichVu = new CanHo_DichVu();
            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("select * from CanHo_DichVu where IdCanHo = '"+ IdCanHo + "' ", conn);
                int count = (cmd.ExecuteScalar() == null ? - 1 : 1);

                if (count > 0) {
                    cmd.CommandText = "UPDATE CanHo_DichVu SET IdDichVu = '" + IdDichVu + "'  WHERE IdCanHo = '" + IdCanHo + "' ";
                    cmd.ExecuteNonQuery();

                } else {
                    cmd.CommandText = "INSERT INTO CanHo_DichVu (IdCanHo,IdDichVu ) VALUES('" + IdCanHo + "', '" + IdDichVu + "') ";
                    cmd.ExecuteNonQuery();
                }
                cmd.CommandText = "SELECT * FROM CanHo_DichVu WHERE IdCanHo = '" + IdCanHo + "' ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        canHo_DichVu.IdDichVu = reader["IdDichVu"].ToString();
                        canHo_DichVu.IdCanHo = reader["IdCanHo"].ToString();
                    }
                }

            }

            return canHo_DichVu;
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

        public List<CanHo_DichVu> GetListCanHo_DichVu()
        {
            List<CanHo_DichVu> list = new List<CanHo_DichVu>();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("select * from CanHo_DichVu", conn);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new CanHo_DichVu()
                        {
                            IdCanHo = reader["IdCanHo"].ToString(),
                            IdDichVu = reader["IdDichVu"].ToString()
                        });
                    }
                }
            }
            return list;
        }

        public List<HopDong_DichVu> GetListHopDong_DichVu()
        {
            List<HopDong_DichVu> list = new List<HopDong_DichVu>();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("select * from HopDong_DichVu", conn);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new HopDong_DichVu()
                        {
                            IdHopDong = reader["IdHopDong"].ToString(),
                            IdDichVu = reader["IdDichVu"].ToString(),
                            DonGia = reader["DonGia"].ToString(),
                            IdHopDong_DichVu = reader["IdHopDong_DichVu"].ToString()
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
                            NgayCap = reader["NgayCap"].ToString(),
                            NoiCap = reader["NoiCap"].ToString(),
                            Password = reader["Password"].ToString()
                        });
                    }
                }
            }
            return list;
        }


        public HoaDon updateHoaDon(string IdHoaDon, string IdCanHo, string SoPhieu, string NgayTao, string SoTien, string SoDienMoi, string SoNuocMoi)
        {
            HoaDon hoadon = new HoaDon();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("UPDATE HoaDon SET IdCanHo = '" + IdCanHo + "', SoPhieu = '" + SoPhieu + "', NgayTao = '" + NgayTao + "', SoTien = '" + SoTien + "', SoDienMoi = '" + SoDienMoi + "', SoNuocMoi = '" + SoNuocMoi + "'   WHERE IdHoaDon = '" + IdHoaDon + "'  ", conn);
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
                        hoadon.IdPhieuThu = reader["IdPhieuThu"].ToString();
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


        public HopDong addHopDong(string ChuHopDong,string IdCanHo, string SoTienCoc,string NgayBD, string NgayKT,string GhiChu, string IdKhachHang, string TienDien, string TienNuoc, string SoDienBd, string SoNuocBd)
        {
            HopDong hopdong = new HopDong();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("INSERT INTO HopDong (ChuHopDong, IdCanHo, SoTienCoc, NgayBD,NgayKT, GhiChu, IdKhachHang, TienDien, TienNuoc, SoDienBd, SoNuocBd) VALUES('" + ChuHopDong + "', '" + IdCanHo + "', '" + SoTienCoc + "', '" + NgayBD + "', '" + NgayKT + "', '" + GhiChu + "', '" + IdKhachHang + "', '" + TienDien + "', '" + TienNuoc + "', '" + SoDienBd + "', '" + SoNuocBd + "') ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM HopDong ORDER BY IdHopDong DESC LIMIT 1 ";

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
                        hopdong.IdKhachHang = reader["IdKhachHang"].ToString();
                        hopdong.TienDien = reader["TienDien"].ToString();
                        hopdong.TienNuoc = reader["TienNuoc"].ToString();
                        hopdong.SoDienBd = reader["SoDienBd"].ToString();
                        hopdong.SoNuocBd = reader["SoNuocBd"].ToString();

                    }
                }
            }

            return hopdong;
        }


        public Account AddAccount(string Email, string MatKhau, string SDT)
        {
            Account account = new Account();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("INSERT INTO Account (Email, MatKhau, SDT) VALUES('" + Email + "', '" + MatKhau + "', '" + SDT + "') ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM Account ORDER BY IdAccount DESC LIMIT 1 ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        account.IdAccount = reader["IdAccount"].ToString();
                        account.Email = reader["Email"].ToString();
                        account.MatKhau = reader["MatKhau"].ToString();
                        account.HoTen = reader["HoTen"].ToString();
                        account.Gioitinh = reader["GioiTinh"].ToString();
                        account.NamSinh = reader["NamSinh"].ToString();
                        account.SDT = reader["SDT"].ToString();
                        account.DiaChi = reader["DiaChi"].ToString();
                    }
                }
            }

            return account;
        }

        public CanHo addCanHo( string DonGia, string DienTich, string DiaChi,  string TieuDe,  string MoTa, string AnhCanHo, string NgayTao)
        {
            CanHo phong = new CanHo();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("INSERT INTO CanHo (DonGia, DienTich, DiaChi, TieuDe,MoTa, AnhCanHo, NgayTao) VALUES('" + DonGia + "', '" + DienTich + "', '" + DiaChi + "', '" + TieuDe + "', '" + MoTa + "', '"+ AnhCanHo + "', '" + NgayTao + "') ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM CanHo ORDER BY IdCanHo DESC LIMIT 1 ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        phong.IdCanHo = reader["IdCanHo"].ToString();
                        phong.DonGia = reader["DonGia"].ToString();
                        phong.DienTich = reader["DienTich"].ToString();
                        phong.DiaChi = reader["DiaChi"].ToString();
                        phong.TieuDe = reader["TieuDe"].ToString();
                        phong.MoTa = reader["MoTa"].ToString();
                        phong.AnhCanHo = reader["AnhCanHo"].ToString();
                        phong.NgayTao = reader["NgayTao"].ToString();
                    }
                }
            }

            return phong;
        }


        public ChiTietHoaDon addChiTietHoaDon(string Id_HoaDon, string TenDichVu, string SoCu, string SoMoi, string DonGia)
        {
            ChiTietHoaDon phong = new ChiTietHoaDon();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("INSERT INTO ChiTietHoaDon (Id_HoaDon, TenDichVu, SoCu, SoMoi,DonGia) VALUES('" + Id_HoaDon + "', '" + TenDichVu + "', '" + SoCu + "', '" + SoMoi + "', '" + DonGia + "') ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM CanHo ORDER BY IdCanHo DESC LIMIT 1 ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        phong.Id_CTHD = reader["Id_CTHD"].ToString();
                        phong.Id_HoaDon = reader["Id_HoaDon"].ToString();
                        phong.TenDichVu = reader["TenDichVu"].ToString();
                        phong.SoCu = reader["SoCu"].ToString();
                        phong.SoMoi = reader["SoMoi"].ToString();
                        phong.DonGia = reader["DonGia"].ToString();
                    }
                }
            }

            return phong;
        }

        public HopDong_DichVu addHopDong_DichVu(string IdHopDong, string IdDichVu, string DonGia)
        {
            HopDong_DichVu phong = new HopDong_DichVu();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("INSERT INTO HopDong_DichVu (IdHopDong, IdDichVu, DonGia) VALUES('" + IdHopDong + "', '" + IdDichVu + "', '" + DonGia + "') ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM HopDong_DichVu ORDER BY IdHopDong_DichVu DESC LIMIT 1 ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        phong.IdHopDong_DichVu = reader["IdHopDong_DichVu"].ToString();
                        phong.IdHopDong = reader["IdHopDong"].ToString();
                        phong.IdDichVu = reader["IdDichVu"].ToString();
                        phong.DonGia = reader["DonGia"].ToString();
                    }
                }
            }

            return phong;
        }

        public DichVu addDichvu(string TenDichVu, string donvi)
        {
            DichVu phong = new DichVu();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("INSERT INTO DichVu (TenDichVu, Donvi) VALUES('" + TenDichVu + "', '" + donvi + "') ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM DichVu ORDER BY IdDichVu DESC LIMIT 1 ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        phong.TenDichVu = reader["TenDichVu"].ToString();
                        phong.DonVi = reader["DonVi"].ToString();
                    }
                }
            }

            return phong;
        }



        public KhachHang addKhachHang( string TenKH,  string IdCanHo,  string SDT, string CMND,  string NgayCap, string NoiCap)
        {
                KhachHang khachhang = new KhachHang();

                using (MySqlConnection conn = GetConnection())
                {
                    conn.Open();
                MySqlCommand cmd = new MySqlCommand("INSERT INTO KhachHang (TenKH, IdCanHo, SDT, CMND, NgayCap, NoiCap) VALUES('" + TenKH + "', '" + IdCanHo + "', '" + SDT + "', '" + CMND + "','" + NgayCap + "','" + NoiCap + "' ) ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM KhachHang ORDER BY IdKhachHang DESC LIMIT 1 ";

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
                            khachhang.NgayCap = reader["NgayCap"].ToString();
                            khachhang.NoiCap = reader["NoiCap"].ToString();
                            khachhang.Password = reader["Password"].ToString();
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
                MySqlCommand cmd = new MySqlCommand("UPDATE PhieuChi SET Sotien = '"+ SoTien+ "' , Ngay = '"+ Ngay + "', DienGiai = '"+DienGiai+ "', IdCanHo = '"+ IdCanHo + "' WHERE IdPhieuChi = '" + IdPhieuChi+"'    ", conn);
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

        public Account updateAccount(string IdAccount, string HoTen, string GioiTinh, string NamSinh, string SDT, string DiaChi, string CMND,  string NgayCap,  string NoiCap)
        {
            Account account = new Account();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("UPDATE Account SET HoTen = '" + HoTen + "' , GioiTinh = '" + GioiTinh + "', NamSinh = '" + NamSinh + "', SDT = '" + SDT + "', DiaChi = '" + DiaChi + "', CMND = '" + CMND + "', NgayCap = '" + NgayCap + "', NoiCap = '" + NoiCap + "' WHERE IdAccount = '" + IdAccount + "'    ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM Account WHERE IdAccount = '" + IdAccount + "' ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        account.IdAccount = reader["IdAccount"].ToString();
                        account.Email = reader["Email"].ToString();
                        account.MatKhau = reader["MatKhau"].ToString();
                        account.HoTen = reader["Hoten"].ToString();
                        account.Gioitinh = reader["Gioitinh"].ToString();
                        account.NamSinh = reader["NamSinh"].ToString();
                        account.SDT = reader["SDT"].ToString();
                        account.DiaChi = reader["DiaChi"].ToString();
                        account.CMND = reader["CMND"].ToString();
                        account.NgayCap = reader["NgayCap"].ToString();
                        account.NoiCap = reader["NoiCap"].ToString();

                    }
                }
            }

            return account;
        }


        public CanHo updateCanHo(string IdCanHo, string DonGia, string DienTich,  string DiaChi,  string TieuDe, string MoTa,  string AnhCanHo, string NgayTao)
        {
            CanHo phong = new CanHo();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("UPDATE CanHo SET DonGia = '" + DonGia + "' , DienTich = '" + DienTich + "', DiaChi = '" + DiaChi + "', TieuDe = '" + TieuDe + "', MoTa = '" + MoTa + "', AnhCanHo = '" + AnhCanHo + "', NgayTao = '" + NgayTao + "' WHERE IdCanHo = '" + IdCanHo + "' ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM CanHo WHERE IdCanHo = '" + IdCanHo + "' ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        phong.IdCanHo = reader["IdCanHo"].ToString();
                        phong.DonGia = reader["DonGia"].ToString();
                        phong.DienTich = reader["DienTich"].ToString();
                        phong.DiaChi = reader["DiaChi"].ToString();
                        phong.TieuDe = reader["TieuDe"].ToString();
                        phong.MoTa = reader["MoTa"].ToString();
                        phong.AnhCanHo = reader["AnhCanHo"].ToString();
                        phong.NgayTao = reader["NgayTao"].ToString();
                    }
                }
            }

            return phong;
        }

        public HopDong_DichVu AddOrUpdateHopDong_DichVu( string IdHopDong, string IdDichVu,  string DonGia)
        {
            HopDong_DichVu canHo_DichVu = new HopDong_DichVu();
            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("select * from HopDong_DichVu where IdHopDong = '" + IdHopDong + "' and IdDichVu = '" + IdDichVu + "' ", conn);
                int count = (cmd.ExecuteScalar() == null ? -1 : 1);

                if (count > 0)
                {
                    cmd.CommandText = "UPDATE HopDong_DichVu SET DonGia = '" + DonGia + "'  WHERE IdHopDong = '" + IdHopDong + "' and IdDichVu = '" + IdDichVu + "' ";
                    cmd.ExecuteNonQuery();

                }
                else
                {
                    cmd.CommandText = "INSERT INTO HopDong_DichVu (IdHopDong,IdDichVu,DonGia ) VALUES('" + IdHopDong + "', '" + IdDichVu + "', '" + DonGia + "') ";
                    cmd.ExecuteNonQuery();
                }
                cmd.CommandText = "SELECT * FROM HopDong_DichVu WHERE IdHopDong = '" + IdHopDong + "' AND IdDichVu = '"+ IdDichVu + "' ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        canHo_DichVu.IdHopDong = reader["IdHopDong"].ToString();
                        canHo_DichVu.IdDichVu = reader["IdDichVu"].ToString();
                        canHo_DichVu.DonGia = reader["DonGia"].ToString();
                        canHo_DichVu.IdHopDong_DichVu = reader["IdHopDong_DichVu"].ToString();
                    }
                }

            }

            return canHo_DichVu;
        }

        public DichVu updateDichVu(string IdDichVu, string TenDichVu, string donvi)
        {
            DichVu dichvu = new DichVu();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("UPDATE DichVu SET TenDichVu = '" + TenDichVu + "' ,  Donvi = '" + donvi + "' WHERE IdDichVu = '" + IdDichVu + "' ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM DichVu WHERE IdDichVu = '" + IdDichVu + "' ";

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        dichvu.IdDichVu = reader["IdDichVu"].ToString();
                        dichvu.TenDichVu = reader["TenDichVu"].ToString();
                        dichvu.DonVi = reader["DonVi"].ToString();
                    }
                }
            }

            return dichvu;
        }

        public HopDong updateHopDong(string IdHopDong,string ChuHopDong, string IdCanHo, string SoTienCoc, string NgayBD, string NgayKT, string GhiChu, string IdKhachHang, string TienDien, string TienNuoc,  string SoDienBd, string SoNuocBd)
        {
            HopDong hopdong = new HopDong();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("UPDATE HopDong SET ChuHopDong = '" + ChuHopDong + "' , IdCanHo = '" + IdCanHo + "', SoTienCoc = '" + SoTienCoc + "', NgayBD = '" + NgayBD + "', NgayKT = '" + NgayKT + "', GhiChu = '" + GhiChu + "', IdKhachHang = '" + IdKhachHang + "', TienDien = '" + TienDien + "', TienNuoc = '" + TienNuoc + "', SoDienBd = '" + SoDienBd + "', SoNuocBd = '" + SoNuocBd + "'  WHERE IdHopDong = '" + IdHopDong + "' ", conn);
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
                        hopdong.IdKhachHang = reader["IdKhachHang"].ToString();
                        hopdong.TienDien = reader["TienDien"].ToString();
                        hopdong.TienNuoc = reader["TienNuoc"].ToString();
                        hopdong.SoDienBd = reader["SoDienBd"].ToString();
                        hopdong.SoNuocBd = reader["SoNuocBd"].ToString();
                    }
                }
            }

            return hopdong;
        }


        public KhachHang updateKhachHang(string IdKhachHang, string TenKH, string IdCanHo, string NgaySinh, string GioiTinh, string SDT, string Email, string CMND, string Quequan,string NgayCap,  string NoiCap,string Password)
        {
            KhachHang khachhang = new KhachHang();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("UPDATE KhachHang SET TenKH = '" + TenKH + "' , IdCanHo = '" + IdCanHo + "', NgaySinh = '" + NgaySinh + "', GioiTinh = '"+ GioiTinh + "', SDT = '" + SDT + "', Email = '" + Email + "', CMND = '" + CMND + "', Quequan = '" + Quequan + "', NgayCap = '" + NgayCap + "', NoiCap = '" + NoiCap + "', Password = '" + Password + "'  WHERE IdKhachHang = '" + IdKhachHang + "'    ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM KhachHang WHERE IdKhachHang = '" + IdKhachHang + "' ";

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
                        khachhang.NgayCap = reader["NgayCap"].ToString();
                        khachhang.NoiCap = reader["NoiCap"].ToString();
                        khachhang.Password = reader["Password"].ToString();
                    }
                }
            }

            return khachhang;
        }


        public KhachHang updateKhachHang_HopDong( string IdKhachHang,  string TenKH,  string IdCanHo,  string CMND, string NgayCap,  string NoiCap,string SDT)
        {
            KhachHang khachhang = new KhachHang();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("UPDATE KhachHang SET TenKH = '" + TenKH + "' , IdCanHo = '" + IdCanHo + "', CMND = '" + CMND + "', NgayCap = '" + NgayCap + "', NoiCap = '" + NoiCap + "', SDT = '" + SDT + "'  WHERE IdKhachHang = '" + IdKhachHang + "'    ", conn);
                cmd.ExecuteNonQuery();

                cmd.CommandText = "SELECT * FROM KhachHang WHERE IdKhachHang = '" + IdKhachHang + "' ";

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
                        khachhang.NgayCap = reader["NgayCap"].ToString();
                        khachhang.NoiCap = reader["NoiCap"].ToString();
                        khachhang.Password = reader["Password"].ToString();
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

        public List<ChiTietHoaDon> GetListChiTietHoaDon()
        {
            List<ChiTietHoaDon> list = new List<ChiTietHoaDon>();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("select * from ChiTietHoaDon", conn);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new ChiTietHoaDon()
                        {
                            Id_CTHD = reader["Id_CTHD"].ToString(),
                            Id_HoaDon = reader["Id_HoaDon"].ToString(),
                            TenDichVu = reader["TenDichVu"].ToString(),
                            SoCu = reader["SoCu"].ToString(),
                            SoMoi = reader["SoMoi"].ToString(),
                            DonGia = reader["DonGia"].ToString()
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
                            IdDichVu = reader["IdDichVu"].ToString(),
                            TenDichVu = reader["TenDichVu"].ToString(),
                            DonVi = reader["DonVi"].ToString()
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
                            DonGia = reader["DonGia"].ToString(),
                            DienTich = reader["DienTich"].ToString(),
                            DiaChi = reader["DiaChi"].ToString(),
                            TieuDe = reader["TieuDe"].ToString(),
                             MoTa = reader["MoTa"].ToString(),
                            AnhCanHo = reader["AnhCanHo"].ToString(),
                            NgayTao = reader["NgayTao"].ToString()

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
                            HoTen = reader["HoTen"].ToString(),
                            Gioitinh = reader["GioiTinh"].ToString(),
                            NamSinh = reader["NamSinh"].ToString(),
                            SDT = reader["SDT"].ToString(),
                            DiaChi = reader["DiaChi"].ToString(),
                            CMND = reader["CMND"].ToString(),
                            NgayCap = reader["NgayCap"].ToString(),
                            NoiCap = reader["NoiCap"].ToString()
                        });
                    }
                }
            }
            return list;
        }



        public List<KhachHang> GetInformationKhachHang(string email, string password)
        {
            List<KhachHang> list = new List<KhachHang>();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("select * from KhachHang where Email = '" + email + "' AND Password = '" + password + "' ", conn);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new KhachHang()
                        {
                            IdKhachHang = reader["IdKhachHang"].ToString(),
                        IdCanHo = reader["IdCanHo"].ToString(),
                        TenKH = reader["TenKH"].ToString(),
                        NgaySinh = reader["NgaySinh"].ToString(),
                        GioiTinh = reader["GioiTinh"].ToString(),
                        SDT = reader["SDT"].ToString(),
                        Email = reader["Email"].ToString(),
                        CMND = reader["CMND"].ToString(),
                        Quequan = reader["Quequan"].ToString(),
                        NgayCap = reader["NgayCap"].ToString(),
                        NoiCap = reader["NoiCap"].ToString(),
                        Password = reader["Password"].ToString()
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
                            IdKhachHang = reader["IdKhachHang"].ToString(),
                            TienDien = reader["TienDien"].ToString(),
                            TienNuoc = reader["TienNuoc"].ToString(),
                            SoDienBd = reader["SoDienBd"].ToString(),
                            SoNuocBd = reader["SoNuocBd"].ToString()


                        });
                    }
                }
            }
            return list;
        }


    }
}
