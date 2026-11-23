using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.IO.Compression;
using System.Security;
using System.Text;
using System.Xml;

namespace Negocios.Utilidades
{
    public class HojaExcel
    {
        public string Nombre { get; set; }
        public string[] Encabezados { get; set; } // null si la hoja no lleva fila de titulos
        public List<object[]> Filas { get; set; } = new List<object[]>();
        public double[] Anchos { get; set; }
        public bool PrimeraColumnaNegrita { get; set; }
    }

    // arma un archivo xlsx que es +- un izp con xml adentro xd
    public static class ExcelSimple
    {
        private const string Ns = "http://schemas.openxmlformats.org/spreadsheetml/2006/main";
        private const string NsRel = "http://schemas.openxmlformats.org/officeDocument/2006/relationships";

        public static byte[] Crear(List<HojaExcel> hojas)
        {
            if (hojas == null || hojas.Count == 0) throw new ArgumentException("No hay hojas para el archivo");
            using (var ms = new MemoryStream())
            {
                using (var zip = new ZipArchive(ms, ZipArchiveMode.Create, true))
                {
                    var tipos = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><Types xmlns=\"http://schemas.openxmlformats.org/package/2006/content-types\"><Default Extension=\"rels\" ContentType=\"application/vnd.openxmlformats-package.relationships+xml\"/><Default Extension=\"xml\" ContentType=\"application/xml\"/><Override PartName=\"/xl/workbook.xml\" ContentType=\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml\"/><Override PartName=\"/xl/styles.xml\" ContentType=\"application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml\"/>");
                    var libro = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><workbook xmlns=\"" + Ns + "\" xmlns:r=\"" + NsRel + "\"><sheets>");
                    var rels = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\">");

                    for (int i = 0; i < hojas.Count; i++)
                    {
                        int n = i + 1;
                        tipos.Append("<Override PartName=\"/xl/worksheets/sheet" + n + ".xml\" ContentType=\"application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml\"/>");
                        libro.Append("<sheet name=\"" + SecurityElement.Escape(NombreHoja(hojas[i].Nombre, n)) + "\" sheetId=\"" + n + "\" r:id=\"rId" + n + "\"/>");
                        rels.Append("<Relationship Id=\"rId" + n + "\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet" + n + ".xml\"/>");
                        Escribir(zip, "xl/worksheets/sheet" + n + ".xml", XmlHoja(hojas[i]));
                    }
                    tipos.Append("</Types>");
                    libro.Append("</sheets></workbook>");
                    rels.Append("<Relationship Id=\"rIdEstilos\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles\" Target=\"styles.xml\"/></Relationships>");

                    Escribir(zip, "[Content_Types].xml", tipos.ToString());
                    Escribir(zip, "_rels/.rels", "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\"><Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument\" Target=\"xl/workbook.xml\"/></Relationships>");
                    Escribir(zip, "xl/workbook.xml", libro.ToString());
                    Escribir(zip, "xl/_rels/workbook.xml.rels", rels.ToString());
                    Escribir(zip, "xl/styles.xml", Estilos());
                }
                return ms.ToArray();
            }
        }

        private static void Escribir(ZipArchive zip, string ruta, string contenido)
        {
            ZipArchiveEntry e = zip.CreateEntry(ruta);
            using (var w = new StreamWriter(e.Open(), new UTF8Encoding(false))) w.Write(contenido);
        }

        // estilos: 0 normal, 1 encabezado azul, 2 numero con dos decimales, 3 negrita
        private static string Estilos()
        {
            return "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><styleSheet xmlns=\"" + Ns + "\">"
                + "<fonts count=\"3\"><font><sz val=\"11\"/><name val=\"Calibri\"/></font><font><b/><sz val=\"11\"/><color rgb=\"FFFFFFFF\"/><name val=\"Calibri\"/></font><font><b/><sz val=\"11\"/><name val=\"Calibri\"/></font></fonts>"
                + "<fills count=\"3\"><fill><patternFill patternType=\"none\"/></fill><fill><patternFill patternType=\"gray125\"/></fill><fill><patternFill patternType=\"solid\"><fgColor rgb=\"FF1E3C72\"/><bgColor indexed=\"64\"/></patternFill></fill></fills>"
                + "<borders count=\"1\"><border><left/><right/><top/><bottom/><diagonal/></border></borders>"
                + "<cellStyleXfs count=\"1\"><xf numFmtId=\"0\" fontId=\"0\" fillId=\"0\" borderId=\"0\"/></cellStyleXfs>"
                + "<cellXfs count=\"4\"><xf numFmtId=\"0\" fontId=\"0\" fillId=\"0\" borderId=\"0\" xfId=\"0\"/>"
                + "<xf numFmtId=\"0\" fontId=\"1\" fillId=\"2\" borderId=\"0\" xfId=\"0\" applyFont=\"1\" applyFill=\"1\" applyAlignment=\"1\"><alignment horizontal=\"center\" vertical=\"center\" wrapText=\"1\"/></xf>"
                + "<xf numFmtId=\"2\" fontId=\"0\" fillId=\"0\" borderId=\"0\" xfId=\"0\" applyNumberFormat=\"1\"/>"
                + "<xf numFmtId=\"0\" fontId=\"2\" fillId=\"0\" borderId=\"0\" xfId=\"0\" applyFont=\"1\"/></cellXfs>"
                + "<cellStyles count=\"1\"><cellStyle name=\"Normal\" xfId=\"0\" builtinId=\"0\"/></cellStyles></styleSheet>";
        }

        private static string XmlHoja(HojaExcel h)
        {
            bool conTitulos = h.Encabezados != null && h.Encabezados.Length > 0;
            int columnas = conTitulos ? h.Encabezados.Length : 1;
            foreach (object[] f in h.Filas) if (f.Length > columnas) columnas = f.Length;

            var sb = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><worksheet xmlns=\"" + Ns + "\">");
            sb.Append(conTitulos ? "<sheetViews><sheetView workbookViewId=\"0\"><pane ySplit=\"1\" topLeftCell=\"A2\" activePane=\"bottomLeft\" state=\"frozen\"/></sheetView></sheetViews>" : "<sheetViews><sheetView workbookViewId=\"0\"/></sheetViews>");
            if (h.Anchos != null && h.Anchos.Length > 0)
            {
                sb.Append("<cols>");
                for (int i = 0; i < h.Anchos.Length; i++)
                    sb.Append("<col min=\"" + (i + 1) + "\" max=\"" + (i + 1) + "\" width=\"" + h.Anchos[i].ToString(CultureInfo.InvariantCulture) + "\" customWidth=\"1\"/>");
                sb.Append("</cols>");
            }

            sb.Append("<sheetData>");
            int fila = 1;
            if (conTitulos)
            {
                sb.Append("<row r=\"1\" ht=\"30\" customHeight=\"1\">");
                for (int c = 0; c < h.Encabezados.Length; c++) sb.Append(Texto(Ref(c, 1), h.Encabezados[c], 1));
                sb.Append("</row>");
                fila = 2;
            }
            foreach (object[] datos in h.Filas)
            {
                sb.Append("<row r=\"" + fila + "\">");
                for (int c = 0; c < datos.Length; c++) sb.Append(Celda(Ref(c, fila), datos[c], c == 0 && h.PrimeraColumnaNegrita));
                sb.Append("</row>");
                fila++;
            }
            sb.Append("</sheetData>");
            if (conTitulos && h.Filas.Count > 0) sb.Append("<autoFilter ref=\"A1:" + Ref(columnas - 1, fila - 1) + "\"/>");
            sb.Append("</worksheet>");
            return sb.ToString();
        }

        private static string Celda(string r, object valor, bool negrita)
        {
            if (valor == null) return "";
            if (valor is int || valor is long || valor is short || valor is byte) return "<c r=\"" + r + "\"><v>" + Convert.ToString(valor, CultureInfo.InvariantCulture) + "</v></c>";
            if (valor is decimal || valor is double || valor is float) return "<c r=\"" + r + "\" s=\"2\"><v>" + Convert.ToString(valor, CultureInfo.InvariantCulture) + "</v></c>";
            if (valor is DateTime time) return Texto(r, time.ToString("dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture), negrita ? 3 : 0);
            return Texto(r, Convert.ToString(valor, CultureInfo.InvariantCulture), negrita ? 3 : 0);
        }

        // el texto va como inlineStr y asi no hace falta la tabla de textos compartidos
        private static string Texto(string r, string texto, int estilo)
        {
            var limpio = new StringBuilder();
            foreach (char ch in texto ?? "") if (XmlConvert.IsXmlChar(ch)) limpio.Append(ch); // quita lo que rompe el xml
            return "<c r=\"" + r + "\" t=\"inlineStr\"" + (estilo > 0 ? " s=\"" + estilo + "\"" : "") + "><is><t xml:space=\"preserve\">" + SecurityElement.Escape(limpio.ToString()) + "</t></is></c>";
        }

        // la coumna 0 es A u 26 es AA
        private static string Ref(int columna, int fila)
        {
            string letras = "";
            for (int n = columna + 1; n > 0; n = (n - 1) / 26) letras = (char)('A' + (n - 1) % 26) + letras;
            return letras + fila;
        }

        private static string NombreHoja(string nombre, int n)
        {
            var sb = new StringBuilder();
            foreach (char ch in nombre ?? "") if ("[]:*?/\\".IndexOf(ch) < 0) sb.Append(ch);
            string limpio = sb.ToString().Trim();
            if (limpio.Length == 0) limpio = "Hoja" + n;
            return limpio.Length > 31 ? limpio.Substring(0, 31) : limpio;
        }
    }
}