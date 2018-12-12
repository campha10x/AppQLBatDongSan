using System;
namespace BatDongSanAPI.Models
{
    public class CanHo
    {
        private BatDongSanStoreContext context;

        public string IdCanHo { get; set; }

        public string TenCanHo { get; set; }

        public string DienTich { get; set; }

        public string DonGia { get; set; }

        public string DiaChi { get; set; }

        public string TieuDe { get; set; }

        public string MoTa { get; set; }

        public string AnhCanHo { get; set; }

        public string NgayTao { get; set; }
    }
}
