module FormHelper
  def input_class
    "mt-1 block w-full rounded-xl
     bg-gray-50 border border-gray-200
     px-4 py-3
     text-gray-900 placeholder-gray-400
     shadow-sm
     focus:bg-white focus:border-indigo-500
     focus:ring-2 focus:ring-indigo-500/20
     transition"
  end

  def select_class
    input_class
  end
end
