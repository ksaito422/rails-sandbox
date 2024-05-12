RSpec.describe Author, type: :model do
  describe '#books_authored' do
    let(:author) { create(:author, :with_books) }
    let(:books) { author.books.all }

    it 'returns books authored by the author', :aggregate_failures do
      expect(author.books_authored).to eq(books)

      book = author.books_authored.first
      expect(book.title).to eq('鋼の錬金術師1')
    end
  end
end
