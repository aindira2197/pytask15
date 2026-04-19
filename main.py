class CustomIterator:
    def __init__(self, data):
        self.data = data
        self.index = 0

    def __iter__(self):
        return self

    def __next__(self):
        if self.index < len(self.data):
            result = self.data[self.index]
            self.index += 1
            return result
        else:
            raise StopIteration

class Container:
    def __init__(self, data):
        self.data = data

    def custom_iterator(self):
        return CustomIterator(self.data)

class AdvancedIterator:
    def __init__(self, data):
        self.data = data
        self.index = 0

    def __iter__(self):
        return self

    def __next__(self):
        if self.index < len(self.data):
            result = self.data[self.index]
            self.index += 1
            return result
        else:
            raise StopIteration

    def has_next(self):
        return self.index < len(self.data)

    def peek(self):
        if self.index < len(self.data):
            return self.data[self.index]
        else:
            raise StopIteration

def main():
    data = [1, 2, 3, 4, 5]
    custom_iterator = Container(data).custom_iterator()
    advanced_iterator = AdvancedIterator(data)

    print("Custom Iterator:")
    for item in custom_iterator:
        print(item)

    print("Advanced Iterator:")
    while advanced_iterator.has_next():
        print(advanced_iterator.peek())
        advanced_iterator.__next__()

    data = ["apple", "banana", "cherry"]
    custom_iterator = Container(data).custom_iterator()
    advanced_iterator = AdvancedIterator(data)

    print("Custom Iterator:")
    for item in custom_iterator:
        print(item)

    print("Advanced Iterator:")
    while advanced_iterator.has_next():
        print(advanced_iterator.peek())
        advanced_iterator.__next__()

if __name__ == "__main__":
    main()