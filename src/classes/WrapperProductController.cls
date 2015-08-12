// Variables declared
public class WrapperProductController {
            public Id ProductId {get; set;}
            public String Discount_Reference {get; set;}
            public String LineType {get; set;}
            public Decimal LineNumber {get; set;}
            public Decimal Quantity {get; set;}
            public List<WrapperProductOption> productoptions{get; set;}
        // Variables declared
                public class WrapperProductOption {
                public Id RecordId {get; set;}
                public Id ProductId {get; set;}
                public Id ProductOptionId {get; set;}
                public String LineType {get; set;}
                public Decimal LineNumber {get; set;}
                public Decimal Quantity {get; set;}
                public String Discount_Reference {get; set;}
                }
        
            }