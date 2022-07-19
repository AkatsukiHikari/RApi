'''
Excel表格处理等
支持csv,xlsx等格式导入导出
'''
module Lib
  module Utils
    class Book

      '''
      READ AND PARSE_CSV
      '''
      def self.parse_csv( csv_path ,  **options )
        data = []
        table = CSV.parse(File.read(csv_path), headers: true)
        table.each do |row|
          puts row
          data << row.to_hash
        end
        data
      end


      def self.read_from_path( csv_file_path , **options )
        CSV.foreach( File.path(csv_file_path) , headers: true ) do |row|
          puts row
        end
      end


    end
  end
end