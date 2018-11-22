using System;
namespace BatDongSanAPI.Models
{
    public class Phong
    {
        private BatDongSanStoreContext context;

        public string idPhong { get; set; }

        public string TenPhong { get; set; }

        public string DonGia { get; set; }

        public string SoDien { get; set; }

        public string SoNuoc { get; set; }

        public string IdNhaTro { get; set; }
    }
}
